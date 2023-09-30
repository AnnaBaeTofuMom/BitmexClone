//
//  OrderBookTableViewCell.swift
//  
//
//  Created by 경원이 on 2023/09/25.
//

import UIKit
import SwiftUI
import RxSwift
import RxRelay

public class OrderBookTableViewCell: UITableViewCell {
    
    var order = PublishRelay<OrderDTO>()
    
    var qtyPriceView = QtyPriceView()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        makeConstraints()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.contentView.addSubview(qtyPriceView)
    }
    
    private func observe() {
        order.subscribe { item in
            self.qtyPriceView.qtyLabel.text = String(item.element?.size ?? 0)
            self.qtyPriceView.priceLabel.text = String(item.element?.price ?? 0)
            
            self.qtyPriceView.updateVolumeBar(ratio: item.element?.volumeRatio ?? 0)
            
            self.qtyPriceView.orderSide.accept(item.element?.side ?? .buy)
        }
        .disposed(by: disposeBag)
    }
    
    private func makeConstraints() {
        qtyPriceView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }
    }
}
