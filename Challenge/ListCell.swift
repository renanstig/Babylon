//
//  ListCell.swift
//  Challenge
//
//  Created by Renan on 10/05/17.
//  Copyright © 2017 babylonChallenge. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    static let Identifier = "listCell"
    @IBOutlet var title: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var titleConstraint: NSLayoutConstraint!
    @IBOutlet var descriptionConstraint: NSLayoutConstraint!
    
    func configureCellWithData(list: Post) {
        title.text = list.title
        descriptionLabel.text = list.body
        titleConstraint.constant = title.requiredHeight
        descriptionConstraint.constant = descriptionLabel.requiredHeight
        
    }

}
