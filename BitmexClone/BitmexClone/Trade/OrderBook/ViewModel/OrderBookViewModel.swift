//
//  OrderBookViewModel.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import Foundation

import RxRelay

protocol OrderBookViewModel {
    var buyOrders: BehaviorRelay<[OrderDTO]> { get }
    var sellOrders: BehaviorRelay<[OrderDTO]> { get }
}
