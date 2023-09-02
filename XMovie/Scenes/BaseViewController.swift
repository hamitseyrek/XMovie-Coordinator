//
//  BaseViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 29.08.2023.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        // Navigation Bar arka plan rengini ayarla
        navigationController?.navigationBar.barTintColor = .white
        
        // Navigation Bar gölge özelliklerini ayarla
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.1
        navigationController?.navigationBar.layer.masksToBounds = false
        
        // Başlık özelliklerini ayarla
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        
        // Sağ üst köşeye bir buton ekleyelim
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(didTapRightButton))
        rightButton.tintColor = .black
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func showLogo() {
        
        let imageView = UIImageView(image: UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .medium)))

        imageView.contentMode = .scaleAspectFit
        
        let xMovieBarButtonItem = UIBarButtonItem(customView: imageView)
        
        self.navigationItem.leftBarButtonItem = xMovieBarButtonItem
    }
    
    @objc func didTapRightButton() {
        // Butona tıklandığında yapılacak işlemler
    }
}
