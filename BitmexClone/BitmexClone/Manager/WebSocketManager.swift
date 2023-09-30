//
//  WebSocketManager.swift
//  
//
//  Created by 경원이 on 2023/09/27.
//

import Foundation
import Combine

public enum WebSocketEndpoints: String {
    case bitmex = "wss://ws.bitmex.com/realtime"
}

public enum WebSocketTopics: String {
    case orderBook = "orderBookL2:XBTUSD"
    case trade = "trade:XBTUSD"
}

public enum WebSocketError: Error {
    case invalidEndpoint
    case decodingError
}

@available(iOS 13.0, *)
public class WebSocketManager {
    static let shared = WebSocketManager()
    
    private var webSocketTasks: [String: URLSessionWebSocketTask] = [:]
    private var pingTimer: Timer?
    
    private init() { }
    
    public func receive<T: Codable>(endpoint: WebSocketEndpoints, topic: WebSocketTopics, modelType: T.Type) -> PassthroughSubject<T, WebSocketError> {
        let subject = PassthroughSubject<T, WebSocketError>() // 새로운 PassthroughSubject 생성

        guard let url = URL(string: endpoint.rawValue) else {
            subject.send(completion: .failure(.invalidEndpoint))
            return subject
        }

        let session = URLSession(configuration: .default)
        
        let webSocketTask = session.webSocketTask(with: url)
        webSocketTasks[topic.rawValue] = webSocketTask

        webSocketTask.resume()
        
        receiveWebSocketMessages(task: webSocketTask, modelType: modelType, subject: subject)
        
        let topic = "{\"op\":\"subscribe\", \"args\":\"\(topic.rawValue)\"}"
        
        webSocketTask.send(.string(topic), completionHandler: { error in
            print(topic)
        })

        // Ping 타이머 시작
        startPing()

        return subject // 생성한 subject를 반환
    }

    
    private func receiveWebSocketMessages<T: Codable>(task: URLSessionWebSocketTask, modelType: T.Type, subject: PassthroughSubject<T, WebSocketError>) {
        task.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print(data)
                case .string(let text):
                    if let jsonData = text.data(using: .utf8) {
                        
                        do {
                            // JSON 데이터를 Person 타입으로 디코딩
                            let model = try JSONDecoder().decode(modelType.self, from: jsonData)
                            subject.send(model)
                        } catch {
                            print(text)
                            print("Error decoding data: \(error)")
                        }
                    }
                @unknown default:
                    break
                }
            case .failure:
                print("데이터받기 실패")
            }

            // 계속해서 WebSocket 메시지를 수신
            self.receiveWebSocketMessages(task: task, modelType: modelType, subject: subject)
        }
    }
    
    private func startPing() {
        pingTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { _ in
            self.ping()
        }
        // 타이머를 시작하기 위해 fire() 메서드를 호출
        pingTimer?.fire()
    }
    
    private func ping() {
        webSocketTasks.forEach({ task in
            task.value.sendPing(pongReceiveHandler: { error in
                if let error = error {
                    print("Ping error: \(error)")
                    // 연결 문제 처리
                } else {
                    print("Ping sent successfully")
                }
            })
        })
    }
    
    deinit {
        // 객체가 해제될 때 WebSocket 연결 종료 및 타이머 해제
        
        webSocketTasks.forEach { task in
            task.value.cancel()
        }
        
        pingTimer?.invalidate()
    }
}
