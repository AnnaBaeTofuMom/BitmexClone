//
//  RecentTradesViewModelInterface.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import Foundation

import RxRelay

protocol RecentTradesViewModel {
    var recentTrades: BehaviorRelay<[TradeDTO]> { get }
}
