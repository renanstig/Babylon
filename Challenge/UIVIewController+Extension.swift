//
//  UIVIewController+Extension.swift
//  Challenge
//
//  Created by Renan on 11/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//


import UIKit


extension UIViewController {
    
    func handleError(error: String) {
        let alertView = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(defaultAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
