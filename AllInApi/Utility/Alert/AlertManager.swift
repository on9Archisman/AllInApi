//
//  AlertManager.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation
import UIKit

protocol AlertManagerProtocol {
    static func showAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        buttonTitle: String,
        completion: (() -> Void)?
    )
    
    static func showConfirmationAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        yesButtonTitle: String,
        noButtonTitle: String,
        yesCompletion: (() -> Void)?,
        noCompletion: (() -> Void)?
    )
}

struct AlertManager: AlertManagerProtocol {
    static func showAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        buttonTitle: String,
        completion: (() -> Void)? = nil
    ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alertVC.addAction(alertAction)
        onViewController.present(alertVC, animated: true, completion: nil)
    }
    
    static func showConfirmationAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        yesButtonTitle: String,
        noButtonTitle: String,
        yesCompletion: (() -> Void)? = nil,
        noCompletion: (() -> Void)? = nil
    ) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionYes = UIAlertAction(title: yesButtonTitle, style: .default) { _ in
            yesCompletion?()
        }
        alertVC.addAction(alertActionYes)
        
        let alertActionNo = UIAlertAction(title: noButtonTitle, style: .cancel) { _ in
            noCompletion?()
        }
        alertVC.addAction(alertActionNo)
        
        onViewController.present(alertVC, animated: true, completion: nil)
    }
}
