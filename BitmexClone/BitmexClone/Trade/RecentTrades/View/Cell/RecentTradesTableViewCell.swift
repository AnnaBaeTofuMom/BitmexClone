//
//  RecentTradesTableViewCell.swift
//  Bitmex
//
//  Created by 경원이 on 2023/09/30.
//

import UIKit

import RxRelay
import RxSwift

class RecentTradesTableViewCell: UITableViewCell {
    
    var trade = PublishRelay<TradeDTO>()
    
    var disposeBag = DisposeBag()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "qty"
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.text = "price(USD)"
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "qty"
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        makeConstraints()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        trade.observe(on: MainScheduler.asyncInstance).subscribe { [weak self] trade in
            self?.qtyLabel.text = String(trade.size)
            self?.priceLabel.text = String(trade.price)
            self?.timeLabel.text = String(trade.timestamp)
            self?.setTextColor(side: trade.side)
        }.disposed(by: disposeBag)
    }
    
    private func setTextColor(side: OrderSide) {
        self.qtyLabel.textColor = side.textColor
        self.priceLabel.textColor = side.textColor
        self.timeLabel.textColor = side.textColor
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        [qtyLabel, priceLabel, timeLabel].forEach {
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


