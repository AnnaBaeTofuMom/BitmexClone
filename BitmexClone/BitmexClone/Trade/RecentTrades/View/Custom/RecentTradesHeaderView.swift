//
//  RecentTradesHeaderView.swift
//  Bitmex
//
//  Created by 경원이 on 2023/09/30.
//

import UIKit

public class RecentTradesHeaderView: UIView {
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "price(USD)"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "qty"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "time"
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
        
        [priceLabel, qtyLabel, timeLabel].forEach {
            self.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        priceLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(8)
        }
        
        qtyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(8)
        }
    }
}


