//
//  MovieCollectionViewCell.swift
//  XMovie
//
//  Created by Hamit Seyrek on 26.08.2023.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    public func configureCell(image: UIImage?) {
        self.imageView.image = image ?? UIImage(named: "noImage")
    }
}
