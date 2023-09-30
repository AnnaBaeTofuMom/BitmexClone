//
//  RecentTradesViewModel.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import Foundation
import Combine

import RxRelay
import RxSwift

class RecentTradesViewModelImpl: RecentTradesViewModel {
    private let recentTradeQueue = DispatchQueue(label: "recentTrade")
    
    private var cancellables = Set<AnyCancellable>()
    
    let recentTrades = BehaviorRelay<[TradeDTO]>(value: [])
    
    init() {
        subscribeTradeSocket()
    }
    
    private func subscribeTradeSocket() {
        WebSocketManager.shared.receive(endpoint: .bitmex, topic: .trade, modelType: RecentTrade.self).sink { completionWithError in
            print("error occured")
        } receiveValue: { [weak self] model in
            self?.recentTradeQueue.sync {
                self?.accumulateRecentTrades(recentTrades: model)
            }
        }
        .store(in: &cancellables)
    }
    
    private func accumulateRecentTrades(recentTrades: RecentTrade) {
        var origin = self.recentTrades.value
        let mappedDTO = recentTrades.data.map { $0.toDomain() }.reversed()
        origin = Array(mappedDTO + origin.prefix(30))
        
        self.recentTrades.accept(origin)
    }
}
