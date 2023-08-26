//
//  HomeViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private lazy var searchBar = UISearchBar()
    private lazy var tableView = UITableView()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        return l
    }()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .gray
        indicator.startAnimating()
        return indicator
    }()
    
    var tableMovies: [Movie] = []
    var isMoreDataLoadingTV = false
    var collectionMovies: [Movie] = []
    var isMoreDataLoadingCV = false
    
    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.load()
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

extension HomeViewController: HomeViewModelDelegate {
    
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        
        switch output {
            
        case .setLoading(let isLoading):
            self.loadingIndicator.isHidden = !isLoading
            
        case .showMovieList(let movieTVList, let movieCVList):
            self.tableMovies = movieTVList
            self.collectionMovies = movieCVList
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
        case .showMoreLoadCollectionMovieList(let movieList):
            self.collectionMovies = movieList
            self.isMoreDataLoadingCV = false
            self.collectionView.reloadData()
            
        case .showMoreLoadTableMovieList(let movieList):
            self.tableMovies = movieList
            self.isMoreDataLoadingTV = false
            self.tableView.reloadData()
        }
    }
    
    func navigate(to route: HomeViewRoute) {
        
        switch route {
            
        case .movieDetail(let id):
            let viewController = AppBuilder.goToMovieDetail(with: id)
            show(viewController, sender: nil)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(item: self.tableMovies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.tableMovies[indexPath.row]
        viewModel.selectMovie(id: movie.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(image: self.collectionMovies[indexPath.row].posterImage)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = self.collectionMovies[indexPath.row]
        viewModel.selectMovie(id: movie.id)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoadingCV) {
            let scrollViewContentHeight = collectionView.contentSize.width
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.width
            
            if (scrollView.contentOffset.x > scrollOffsetThreshold && collectionView.isDragging) {
                
                isMoreDataLoadingCV = true
                self.viewModel.moreLoadForCollectionView()
            }
        }
        
        if (!isMoreDataLoadingTV) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                
                isMoreDataLoadingTV = true
                self.viewModel.moreLoadForTableView()
            }
        }
    }
}


extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count > 2 {
            self.viewModel.searchMovie(searchText: searchText)
        }
    }
}
