//
//  SellOrderBookTableViewCell.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import UIKit

class SellOrderBookTableViewCell: OrderBookTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.qtyPriceView.updateDirection()
        self.layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
