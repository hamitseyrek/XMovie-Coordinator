//
//  MovieDetailViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit
import SnapKit

class MovieDetailViewController: BaseViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "noImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Lorem ipsum dolor sit amet"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.color = .black
        indicator.startAnimating()
        return indicator
    }()
    
    var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.load()
        self.view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(loadingIndicator)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func handleViewModelOutput(_ output: MovieDetailViewModelOutput) {
        
        switch output {
            
        case .updateTitle(let title):
            self.title = title
            
        case .setLoading(let isLoading):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.loadingIndicator.isHidden = !isLoading
            }
            
        case .showDetail(let movie):
            self.imageView.image = movie.posterImage ?? UIImage(named: "noImage")
            self.titleLabel.text = movie.title
            self.descriptionLabel.text = "\(movie.actors ?? "") \n \(movie.plot ?? "")"
            
        case .showError(let error):
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.descriptionLabel.isHidden = true
                self.titleLabel.text = "Service error: '\(error)'"
            }
        }
    }
}
