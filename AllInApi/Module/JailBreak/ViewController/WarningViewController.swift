//
//  ViewController.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

// This view controller is shown when a jailbreak/rooted device is detected.
class WarningViewController: UIViewController {
    
    // Called after the view has been loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background color to light gray.
        view.backgroundColor = .lightGray
        
        // Show a jailbreak warning alert.
        showAlert()
    }
    
    // Displays a warning alert about the device being rooted.
    fileprivate func showAlert() {
        AlertManager.showAlert(
            onViewController: self,
            title: "Warning",
            message: "Device is rooted, app can't run on jailbroken device",
            buttonTitle: "OK"
        )
    }
}
