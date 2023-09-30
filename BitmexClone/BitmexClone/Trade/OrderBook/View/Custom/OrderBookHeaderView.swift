//
//  OrderBookHeaderView.swift
//  
//
//  Created by 경원이 on 2023/09/25.
//

import UIKit

public class OrderBookHeaderView: UIView {
    
    let buyQtyLabel: UILabel = {
        let label = UILabel()
        label.text = "qty"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "price(USD)"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let sellQtyLabel: UILabel = {
        let label = UILabel()
        label.text = "qty"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupView()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 400, height: 21)
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        [buyQtyLabel, priceLabel, sellQtyLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        buyQtyLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        sellQtyLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(8)
        }
    }
}

