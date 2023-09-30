//
//  RecentTradesViewController.swift
//  
//
//  Created by 배경원 on 2023/09/29.
//

import UIKit

import RxSwift
import RxRelay
import RxDataSources

class RecentTradesViewController: UIViewController {
    
    let viewModel: RecentTradesViewModel
    
    let tableHeaderView = RecentTradesHeaderView()
    
    let tableView = UITableView()
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    public init(viewModel: RecentTradesViewModel) {
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
        viewModel.recentTrades.bind(to: tableView.rx.items) { tableview, indexPath, item in
            if let cell = tableview.dequeueReusableCell(withIdentifier: "RecentTradesTableViewCell") as? RecentTradesTableViewCell {
                cell.trade.accept(item)
                return cell
            } else {
                return UITableViewCell()
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func setupView() {
        
        [tableHeaderView, tableView].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setupTableview() {
        
        [tableView].forEach {
            $0.register(RecentTradesTableViewCell.self, forCellReuseIdentifier: "RecentTradesTableViewCell")
            $0.rowHeight = 24
        }
    }
    
    private func makeConstraints() {
        tableHeaderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(21)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tableHeaderView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
