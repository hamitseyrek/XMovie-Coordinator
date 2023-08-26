//
//  MovieTableViewCell.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {
    
    private lazy var imageViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        addSubview(imageViewIcon)
        imageViewIcon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageViewIcon.snp.right).offset(10)
            make.top.equalTo(imageViewIcon.snp.top)
            make.right.equalToSuperview().offset(-10)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.right.equalTo(titleLabel.snp.right)
        }
    }
    
    public func configureCell(item: Movie) {
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.year
        self.imageViewIcon.image = item.posterImage
    }
}
