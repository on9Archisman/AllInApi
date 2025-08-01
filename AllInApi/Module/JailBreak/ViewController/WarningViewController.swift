//
//  ViewController.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

class WarningViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        showAlert()
    }
    
    fileprivate func showAlert() {
        AlertManager.showAlert(
            onViewController: self,
            title: "Warning",
            message: "Device is rooted, app can't run on jailbroken device",
            buttonTitle: "OK"
        )
    }
}

