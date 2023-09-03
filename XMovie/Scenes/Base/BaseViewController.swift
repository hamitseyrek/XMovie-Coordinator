//
//  BaseViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 29.08.2023.
//

import Foundation
import UIKit
import Reachability

class BaseViewController: UIViewController {
    
    private var reachability: Reachability?
    
    deinit {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureReachability()
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

// MARK: Reachability configuration
extension BaseViewController {
    private func configureReachability() {
        do {
            try reachability = Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: nil)
            try reachability?.startNotifier()
        } catch {
            print("An error occured while trying to create an object from \"Reachability\"")
        }
    }
    
    @objc private func reachabilityChanged() {
        if let reachability = reachability {
            if reachability.connection == .unavailable {
                print("***** no connection")
//                let infoPopupVC = InfoPopupVC(image: R.image.circleExclamation(), _title: "Bağlantı hatası!", _description: "İnternet bağlantınızı açınız.") { [self] in
//                    reachabilityChanged()
//
//                    if reachability.connection == .wifi || reachability.connection == .cellular {
//                        NotificationCenter.default.post(name: NSNotification.Name("connectionWasLost"), object: nil)
//                    }
//                }
//                presentPopup(infoPopupVC)
            }
        }
    }
}


protocol BaseViewModelDelegate: AnyObject {
    func showError(_ error: Error)
    func showHUD()
    func hideHUD()
    
}

// MARK: BaseInterface
extension BaseViewController: BaseViewModelDelegate {
    
    func showError(_ error: Error) {
        UIHelper.hideHUD()
        UIHelper.showError(error: error as? LocalizedError)
    }
    
    func showHUD() {
        UIHelper.showHUD()
    }
    
    func hideHUD() {
        UIHelper.hideHUD()
    }
}
