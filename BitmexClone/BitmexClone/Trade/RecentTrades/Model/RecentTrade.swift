//
//  RecentTrade.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//
import Foundation

// MARK: - RecentTrade
struct RecentTrade: Codable {
    let table, action: String
    let data: [Trade]
}

// MARK: - Datum
struct Trade: Codable {
    let timestamp, symbol, side: String
    let size: Int
    let price: Double
    
    func toDomain() -> TradeDTO {
        let side: OrderSide = self.side == "Buy" ? .buy : .sell
        return TradeDTO(timestamp: timestamp.hhmmssString(), symbol: self.symbol, side: side, size: self.size, price: self.price)
    }
}

struct TradeDTO {
    let timestamp: String
    let symbol: String
    let side: OrderSide
    let size: Int
    let price: Double
}
