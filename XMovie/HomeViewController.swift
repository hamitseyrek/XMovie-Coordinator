//
//  HomeViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    let layout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        return l
    }()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Search..."
        searchBar.layer.borderColor = UIColor.black.cgColor
        searchBar.layer.borderWidth = 2
        searchBar.layer.cornerRadius = 25
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }

        view.addSubview(tableView)
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(3 * (view.frame.height / 5))
        }

        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 2
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    
}
