//
//  GbIconButton.swift
//  postcraft
//
//  Created by LionStar on 2/7/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbIconButton: GbCustomView {
    var btnTapHandler:((_ sender:Any) -> Void)? = nil
    
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

    @IBAction func btnTapped(_ sender: Any) {
        self.iconImageView.alpha = 0.5
        self.titleLabel.alpha = 0.5
        
        UIView.animate(withDuration: 0.3) {
            self.iconImageView.alpha = 1.0
            self.titleLabel.alpha = 1.0
            self.btnTapHandler?(sender)
        }
    }
}
