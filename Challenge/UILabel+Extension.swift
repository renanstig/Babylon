//
//  UILabel+Extensions.swift
//  Challenge
//
//  Created by Renan on 10/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import UIKit
import Foundation

extension UILabel {
    
    public var requiredHeight: CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.height
    }
}
