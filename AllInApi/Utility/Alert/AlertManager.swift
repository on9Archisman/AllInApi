//
//  AlertManager.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation
import UIKit

// MARK: - Protocol defining alert functionalities
protocol AlertManagerProtocol {
    
    /// Show a basic alert with a single OK button
    static func showAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        buttonTitle: String,
        completion: (() -> Void)?
    )
    
    /// Show a confirmation alert with Yes/No buttons
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

// MARK: - AlertManager implementation conforming to AlertManagerProtocol
struct AlertManager: AlertManagerProtocol {
    
    /// Presents a simple alert with a single button
    static func showAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        buttonTitle: String,
        completion: (() -> Void)? = nil
    ) {
        // Create alert controller
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create action button
        let alertAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        // Add action to alert
        alertVC.addAction(alertAction)
        
        // Present alert on provided view controller
        onViewController.present(alertVC, animated: true, completion: nil)
    }
    
    /// Presents a confirmation alert with Yes and No buttons
    static func showConfirmationAlert(
        onViewController: UIViewController,
        title: String,
        message: String,
        yesButtonTitle: String,
        noButtonTitle: String,
        yesCompletion: (() -> Void)? = nil,
        noCompletion: (() -> Void)? = nil
    ) {
        // Create alert controller
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create Yes action
        let alertActionYes = UIAlertAction(title: yesButtonTitle, style: .default) { _ in
            yesCompletion?()
        }
        alertVC.addAction(alertActionYes)
        
        // Create No action
        let alertActionNo = UIAlertAction(title: noButtonTitle, style: .cancel) { _ in
            noCompletion?()
        }
        alertVC.addAction(alertActionNo)
        
        // Present alert on provided view controller
        onViewController.present(alertVC, animated: true, completion: nil)
    }
}
