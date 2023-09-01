//
//  UserViewController.swift
//  XMovie
//
//  Created by Hamit Seyrek on 28.08.2023.
//

import UIKit

class UserViewController: UIViewController {
    
    weak var coordinator: UserCoordinatorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        let button = UIButton()
        button.setTitle("tap me", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .green
        view.addSubview(button)
        
        let label = UILabel()
        label.text = "I did it!"
        label.frame = CGRect(x: button.frame.minX, y: button.frame.maxY + 10, width: 200, height: 50)
        label.backgroundColor = .yellow
        label.textAlignment = .center
        view.addSubview(label)
    }
    
    @objc private func didTapButton() {
        coordinator?.showSecondVC()
    }
}

//extension SecondVC {
//    enum Event {
//        case gotoUserCV
//    }
//}

class SecondVC: UIViewController {
    
    weak var coordinator: UserCoordinatorProtocol?
    
    //    var didSendEventClosure: ((SecondVC.Event) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        self.title = "SecondVC"
        let button = UIButton()
        button.setTitle("This is SecondVCTap", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.backgroundColor = .green
        view.addSubview(button)
        
    }
    
    @objc private func didTapButton() {
        coordinator?.showUserViewController()
        //        didSendEventClosure?(.gotoUserCV)
    }
}
