//
//  HomeViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit
import SnapKit

//extension HomeViewController {
//    enum HomeRoutes {
//        case detail(service: MovieServiceProtocol, id: String)
//    }
//}

class HomeViewController: BaseViewController {
    
//    var homeRouteClosure: ((HomeViewController.HomeRoutes) -> Void)?
    
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
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var footerLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .black
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var noResultsForTableViewLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found."
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var noResultsForCollectionViewLabel: UILabel = {
        let label = UILabel()
        label.text = "No results found."
        label.textAlignment = .center
        label.isHidden = true
        return label
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
    
    weak var coordinator: HomeCoordinatorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "movieTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "movieCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerLoading")

//        self.title = "XMovie"
        viewModel.load()
        setupUI()
        self.showLogo()
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
//            make.top.equalTo(view).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        view.addSubview(tableView)
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 2
        
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.layer.borderWidth = 2
        view.addSubview(collectionView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(1 * (view.frame.height / 5))
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(noResultsForTableViewLabel)
        noResultsForTableViewLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(noResultsForCollectionViewLabel)
        noResultsForCollectionViewLabel.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        
        switch output {
            
        case .setLoading(let isLoading):
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.isHidden = !isLoading
            }
            
        case .getDataForTableView(let movieList, let error):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.tableView.reloadData()
                self.noResultsForTableViewLabel.text = "Service error: '\(error)'"
                self.noResultsForTableViewLabel.isHidden = !self.tableMovies.isEmpty
            }
            self.tableMovies = movieList
            self.isMoreDataLoadingTV = false
            
        case .getDataForCollectionView(let movieList, let error):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.footerLoadingIndicator.stopAnimating()
                self.collectionView.reloadData()
                self.noResultsForCollectionViewLabel.isHidden = !self.collectionMovies.isEmpty
                self.noResultsForCollectionViewLabel.text = "Service error: '\(error)'"
            }
            self.collectionMovies = movieList
            self.isMoreDataLoadingCV = false
        }
    }
    
//    func navigate(to route: HomeViewRoute) {
//
//        switch route {
//
//        case .movieDetail(let id):
//            let viewController = AppBuilder.goToMovieDetail(with: id)
//            show(viewController, sender: nil)
//        }
//    }
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
//        viewModel.selectMovie(id: movie.id)
        coordinator?.showDetailViewController(service: viewModel.service, id: movie.id)
//        homeRouteClosure?(.detail(service: viewModel.service, id: movie.id))
        
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
        coordinator?.showDetailViewController(service: viewModel.service, id: movie.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerLoading", for: indexPath)
            footerLoadingIndicator.center = CGPoint(x: footer.bounds.width / 2, y: footer.bounds.height / 2)
            footer.addSubview(footerLoadingIndicator)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (!isMoreDataLoadingCV) {
            let scrollViewContentHeight = collectionView.contentSize.width
            let scrollOffsetThreshold = scrollViewContentHeight - collectionView.bounds.size.width
            
            if (scrollView.contentOffset.x > scrollOffsetThreshold && collectionView.isDragging) {
                
                isMoreDataLoadingCV = true
                
                self.footerLoadingIndicator.startAnimating()
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
        } else if searchText.count == 0 {
            self.viewModel.searchMovie(searchText: "Star")
        }
        
        noResultsForTableViewLabel.text = "No results found for '\(searchText)'"
    }
}
