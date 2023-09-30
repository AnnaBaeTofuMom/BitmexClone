//
//  ViewController.swift
//  Orderbook
//
//  Created by 경원이 on 2023/09/24.
//

import UIKit
import Combine

import SnapKit

class TradingViewController: UIViewController {
    
    var pageTabBar: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    var pageViewController: UIPageViewController!
    
    var contentViewControllerArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPagingView()
        setupCollectionView()
        
        setupView()
        makeConstraints()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        [pageTabBar, pageViewController.view].forEach {
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        pageTabBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(pageTabBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupPagingView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        
        let firstViewController = OrderBookViewController(viewModel: OrderBookViewModelImpl())
        let secondViewController = RecentTradesViewController(viewModel: RecentTradesViewModelImpl())
        
        contentViewControllerArray = [firstViewController, secondViewController]
        
        if let initialViewController = contentViewControllerArray.first {
            pageViewController.setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
        }
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupCollectionView() {
        pageTabBar.backgroundColor = .white
        pageTabBar.register(TradingTabBarCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        pageTabBar.dataSource = self
        pageTabBar.delegate = self
        view.addSubview(pageTabBar)
        
        pageTabBar.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension TradingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllerArray.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1
        if previousIndex < 0 {
            return nil
        }
        return contentViewControllerArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = contentViewControllerArray.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1
        if nextIndex >= contentViewControllerArray.count {
            return nil
        }
        return contentViewControllerArray[nextIndex]
    }
}

extension TradingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentViewControllerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? TradingTabBarCollectionViewCell else { return UICollectionViewCell() }
        cell.titleLabel.text = indexPath.item == 0 ? "Order Book" : "Recent Trades"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedViewController = contentViewControllerArray[indexPath.item]
        if let currentIndex = contentViewControllerArray.firstIndex(of: selectedViewController) {
            pageViewController.setViewControllers([selectedViewController], direction: (currentIndex > 0) ? .forward : .reverse, animated: true, completion: nil)
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? TradingTabBarCollectionViewCell else { return }
        cell.titleLabel.textColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TradingTabBarCollectionViewCell else { return }
        cell.titleLabel.textColor = .gray
    }
}


