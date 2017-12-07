//
//  GbShareButton.swift
//  postcraft
//
//  Created by LionStar on 2/3/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbShareButton: GbCustomView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var icon: UIImage? {
        get {
            return iconImageView.image
        }
        set(image) {
            iconImageView.image = image
        }
    }
    @IBInspectable var title: String? {
        get {
            return titleLabel.text
        }
        set(text) {
            titleLabel.text = text
        }
    }
}
