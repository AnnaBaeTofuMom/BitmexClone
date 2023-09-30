
import UIKit
import Combine
import SnapKit
import RxSwift
import RxRelay
import RxDataSources

class OrderBookViewController: UIViewController {
    
    let tableHeaderView = OrderBookHeaderView()
    
    let buyTableview = UITableView()
    
    let sellTableview = UITableView()
    
    let viewModel: OrderBookViewModel
    
    var buyOrders = PublishRelay<[OrderDTO]>()
    
    var sellOrders = PublishRelay<[OrderDTO]>()
    
    var disposeBag = DisposeBag()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: OrderBookViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupTableview()
        makeConstraints()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func observe() {
        
        viewModel.buyOrders.observe(on: MainScheduler.asyncInstance).subscribe { [weak self] orders in
            self?.buyOrders.accept(orders)
        }
        .disposed(by: disposeBag)
        
        viewModel.sellOrders.observe(on: MainScheduler.asyncInstance).subscribe { [weak self] orders in
            self?.sellOrders.accept(orders)
        }
        .disposed(by: disposeBag)
        
        buyOrders.bind(to: buyTableview.rx.items) { tableview, indexPath, item in
            if let cell = tableview.dequeueReusableCell(withIdentifier: "OrderBookTableViewCell") as? OrderBookTableViewCell {
                cell.order.accept(item)
                return cell
            } else {
                return UITableViewCell()
            }
        }
        .disposed(by: disposeBag)
        
        sellOrders.bind(to: sellTableview.rx.items) { tableview, indexPath, item in
            if let cell = tableview.dequeueReusableCell(withIdentifier: "SellOrderBookTableViewCell") as? SellOrderBookTableViewCell {
                cell.order.accept(item)
                return cell
            } else {
                return UITableViewCell()
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func setupView() {
        
        [tableHeaderView, buyTableview, sellTableview].forEach {
            view.addSubview($0)
        }
        
        view.backgroundColor = .white
    }
    
    private func setupTableview() {
        
        buyTableview.register(
            OrderBookTableViewCell.self,
            forCellReuseIdentifier: "OrderBookTableViewCell"
        )
        
        buyTableview.rowHeight = 24
        
        sellTableview.register(
            SellOrderBookTableViewCell.self,
            forCellReuseIdentifier: "SellOrderBookTableViewCell"
        )
        
        sellTableview.rowHeight = 24
        
    }
    
    private func makeConstraints() {
        tableHeaderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(21)
        }
        
        buyTableview.snp.makeConstraints { make in
            make.top.equalTo(tableHeaderView.snp.bottom)
            make.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        sellTableview.snp.makeConstraints { make in
            make.top.equalTo(tableHeaderView.snp.bottom)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(buyTableview.snp.trailing)
            make.width.equalToSuperview().dividedBy(2)
        }
    }
}
