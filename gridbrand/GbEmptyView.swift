//
//  GbEmptyView.swift
//  postcraft
//
//  Created by LionStar on 1/13/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbEmptyView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    static func create()->GbEmptyView {
        
        return UINib(nibName: "GbEmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! GbEmptyView
    }

    func setIcon(image:UIImage) {
        self.iconImageView.image = image
    }
    
    func setMessage(message:String) {
        self.messageLabel.text = message
    }
}
