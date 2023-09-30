//
//  TradingTabBarCollectionViewCell.swift
//  BitmexClone
//
//  Created by 경원이 on 2023/09/30.
//

import UIKit

import SnapKit

class TradingTabBarCollectionViewCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
}
