//
//  QtyPriceView.swift
//  
//
//  Created by 경원이 on 2023/09/25.
//

import UIKit
import RxRelay
import RxSwift

public enum OrderSide {
    case buy
    case sell
    
    var volumeColor: UIColor {
        switch self {
        case .buy:
            return UIColor.green.withAlphaComponent(0.4)
        case .sell:
            return UIColor.red.withAlphaComponent(0.2)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .buy:
            return UIColor.green
        case .sell:
            return UIColor.red
        }
    }
}

/// 수량과 가격, 배경에 볼륨만큼 색이 칠해지는 뷰 입니다
/// 초기화시에 수량의 방향을 지정할 수 있습니다.
public class QtyPriceView: UIView {
    var orderSide = PublishRelay<OrderSide>()
    
    let disposeBag = DisposeBag()
    
    let qtyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let volumeBar = UIView()
    
    public init() {
        super.init(frame: .zero)
        setupView()
        makeConstraints()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        orderSide.subscribe { [weak self] side in
            self?.volumeBar.backgroundColor = side.element?.volumeColor
        }
        .disposed(by: disposeBag)
    }
    
    public func updateVolumeBar(ratio: Double) {
        volumeBar.snp.updateConstraints { make in
            make.width.equalTo(50 * ratio)
        }
    }
    
    private func setupView() {
        [qtyLabel, priceLabel, volumeBar].forEach {
            self.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        qtyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
        }
        
        volumeBar.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.width.equalTo(0)
        }
    }
    
    func updateDirection() {
        self.transform = CGAffineTransform(scaleX: -1, y: 1)
        [qtyLabel, priceLabel].forEach {
            $0.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
}
