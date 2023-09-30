//
//  OrderBookViewModel.swift
//  
//
//  Created by 경원이 on 2023/09/27.
//

import Foundation
import Combine
import RxRelay
import RxSwift

enum OrderAction: String, CaseIterable {
    case partial
    case update
    case insert
    case delete
}

class OrderBookViewModelImpl: OrderBookViewModel {
    private let orderbookQueue = DispatchQueue(label: "orderbook")
    
    var buyOrders = BehaviorRelay<[OrderDTO]>(value: [])
    
    var sellOrders = BehaviorRelay<[OrderDTO]>(value: [])
    
    private var internalBuyOrders = BehaviorRelay<[OrderDTO]>(value: [])
    
    private var internalSellOrders = BehaviorRelay<[OrderDTO]>(value: [])
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var disposeBag = DisposeBag()
    
    init() {
        subscribeOrderBookSocket()
        observe()
    }
    
    private func observe() {
        internalBuyOrders.subscribe { [weak self] orders in
            var prefixed = Array(orders.prefix(12))
            prefixed = self?.calculateVolumeRatio(array: prefixed) ?? []
            self?.buyOrders.accept(prefixed)
        }
        .disposed(by: disposeBag)
        
        internalSellOrders.subscribe { [weak self] orders in
            var prefixed = Array(orders.prefix(12))
            prefixed = self?.calculateVolumeRatio(array: prefixed) ?? []
            self?.sellOrders.accept(prefixed)
        }
        .disposed(by: disposeBag)
    }
    
    private func subscribeOrderBookSocket() {
        WebSocketManager.shared.receive(endpoint: .bitmex, topic: .orderBook, modelType: OrderBookL2Model.self).sink { completionWithError in
            print("error occured")
        } receiveValue: { [weak self] model in
            self?.orderbookQueue.async {
                self?.sortOrderBookData(model: model.toDomain())
            }
        }
        .store(in: &cancellables)
    }
    
    private func sortOrderBookData(model: OrderBookDTO) {
        let newOrder = model.data
        
        var buyArray: [OrderDTO] = self.internalBuyOrders.value
        var sellArray: [OrderDTO] = self.internalSellOrders.value
        
        switch model.action {
        case .partial:
            /// 이전에 왔던 모든 값 무시
            buyArray = []
            sellArray = []
            
            newOrder.forEach { order in
                if order.side == .buy {
                    buyArray.append(order)
                } else {
                    sellArray.append(order)
                }
            }
            
        case .update:
            
            for order in newOrder {
                if order.side == .buy {
                    buyArray = self.updateModel(origin: buyArray, newOrder: order)
                } else {
                    sellArray = self.updateModel(origin: sellArray, newOrder: order)
                }
            }
            
        case .insert:
            for order in newOrder {
                if order.side == .buy {
                    buyArray.append(order)
                } else {
                    sellArray.append(order)
                }
            }
            
        case .delete:
            for order in newOrder {
                if order.side == .buy {
                    buyArray.removeAll { $0.id == order.id }
                } else {
                    sellArray.removeAll { $0.id == order.id }
                }
            }
        }
        
        buyArray.sort { $0.price > $1.price }
        sellArray.sort { $0.price < $1.price }
        
        buyArray = Array(buyArray.prefix(16))
        sellArray = Array(sellArray.prefix(16))
        
        if !(self.internalBuyOrders.value == buyArray) {
            self.internalBuyOrders.accept(buyArray)
        }
        
        if !(self.internalSellOrders.value == sellArray) {
            self.internalSellOrders.accept(sellArray)
        }
    }
    
    private func calculateVolumeRatio(array: [OrderDTO]) -> [OrderDTO] {
        guard let maxTotalSize = array.compactMap({ $0.size }).max() else {
                // 만약 주문이 비어있다면 빈 배열을 반환
                return []
            }

            var cumulativeSize = 0.0
            var resultOrders: [OrderDTO] = []

            for order in array {
                if let size = order.size {
                    cumulativeSize += Double(size)
                }

                // 최대값으로 나눈 비율을 계산하여 volumeRatio에 할당
                var updatedOrder = order
                updatedOrder.volumeRatio = cumulativeSize / Double(maxTotalSize)
                resultOrders.append(updatedOrder)
            }

            return resultOrders
    }
    
    private func updateModel(origin: [OrderDTO], newOrder: OrderDTO) -> [OrderDTO] {
        var newOrigin = origin
        
        for i in origin.indices {
            guard let safeitem = origin[safe: i] else { return newOrigin }
            if safeitem.id == newOrder.id {
                newOrigin[i].size = newOrder.size
            }
        }
        
        return newOrigin
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
