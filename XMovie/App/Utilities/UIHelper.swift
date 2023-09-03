//
//  UIHelper.swift
//  XMovie
//
//  Created by Hamit Seyrek on 3.09.2023.
//

import Foundation
import UIKit
import SVProgressHUD

class UIHelper: NSObject {
    
    static func showHUD() {
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
    }
    
    static func hideHUD() {
        SVProgressHUD.dismiss()
    }
    
//    static let pickerDoneButton = UIBarButtonItem(title: "Tamam", style: .done, target: nil, action: nil)
//    static let pickerCancelButton = UIBarButtonItem(title: "İptal", style: .plain, target: nil, action: nil)
//
    static func showError(target1 : UIViewController? = nil, error: LocalizedError?, alertHandler: ((_ alert:UIAlertController, _ desicion:Int) -> Void)? = nil) {

        if let errorDescription = error?.errorDescription {
            let title = (error?.localizedDescription != nil) ? "Hata" : ""
            self.showAlert(title: title, message: errorDescription, alertHandler: alertHandler)
        }
    }
//
//
    static func showAlert(_ target : UIViewController? = nil, title:String, message:String, alertHandler: ((_ alert:UIAlertController, _ desicion:Int) -> Void)? = nil) {

        self.showAlert(target, title: title, message: message, buttons: ["Tamam"], style:.alert, alertHandler: alertHandler)
    }
//
    static var popupWindow: UIWindow?
    static func showAlert(_ target : UIViewController? = nil, title:String?, cancel: String? = "İptal", message:String?, buttons:[String], style:UIAlertController.Style, alertHandler: ((_ alert:UIAlertController, _ desicion:Int) -> Void)?) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        alert.modalPresentationCapturesStatusBarAppearance = true
        alert.setNeedsStatusBarAppearanceUpdate()

        for item in buttons {
            let cancelButton = UIAlertAction(title: item, style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                alertHandler?(alert,buttons.firstIndex(of: item)!)
                popupWindow = nil
            })

            alert.addAction(cancelButton)
        }

        if style == .actionSheet {
            let cancelButton = UIAlertAction(title: cancel, style: UIAlertAction.Style.cancel, handler: { (UIAlertAction) -> Void in
                alertHandler?(alert,buttons.count)
                popupWindow = nil
            })
            alert.addAction(cancelButton)
        }

        if target == nil {

            if #available(iOS 16.0, *) {

                DispatchQueue.main.async {

                    // get topmostViewController
                    //source: https://developer.apple.com/forums/thread/705095
                    var topMostViewController = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).filter { $0.activationState == .foregroundActive }.first?.windows.first?.rootViewController

                    while let presentedViewController = topMostViewController?.presentedViewController {
                        topMostViewController = presentedViewController
                    }

                    topMostViewController?.present(alert, animated: true, completion: nil)
                }
            } else if #available(iOS 13.0, *) {

                let windowScene = UIApplication.shared
                    .connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .first

                if let windowScene = windowScene as? UIWindowScene {
                    popupWindow = UIWindow(windowScene: windowScene)
                }

                popupWindow?.frame = UIScreen.main.bounds
                popupWindow?.backgroundColor = .clear
                popupWindow?.windowLevel = UIWindow.Level.statusBar + 1
                popupWindow?.rootViewController = UIViewController()
                popupWindow?.makeKeyAndVisible()
                popupWindow?.rootViewController?.present(alert, animated: true, completion: nil)

            } else {
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindow.Level.alert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
            }

        }else{
            target!.present(alert, animated: false, completion: nil)
        }
    }
}
