//
//  OrderBookL2Model.swift
//  Orderbook
//
//  Created by 경원이 on 2023/09/24.
//

import Foundation

// MARK: - OrderBookL2
struct OrderBookL2Model: Codable {
    let table: String?
    let action: String?
    let data: [Order]?

    func toDomain() -> OrderBookDTO {
        let actionEnum: OrderAction = OrderAction(rawValue: action ?? "") ?? .insert
        let orders = data?.map { $0.toDomain() } ?? []
        return OrderBookDTO(table: table ?? "", action: actionEnum, data: orders)
    }
}

// MARK: - Order
struct Order: Codable, Equatable {
    var symbol: String
    var id: Int64
    var side: String
    var size: Int?
    var price: Double
    var timestamp: String

    func toDomain() -> OrderDTO {
        let sideEnum: OrderSide = (side.lowercased() == "buy") ? .buy : .sell
        return OrderDTO(symbol: symbol, id: id, side: sideEnum, size: size, price: price, timestamp: timestamp)
    }
}

// MARK: - OrderBookDTO
struct OrderBookDTO {
    let table: String
    let action: OrderAction
    let data: [OrderDTO]
}

// MARK: - OrderDTO
struct OrderDTO: Equatable {
    var symbol: String
    var id: Int64
    var side: OrderSide
    var size: Int?
    var price: Double
    var timestamp: String
    var volumeRatio: Double = 0
}
