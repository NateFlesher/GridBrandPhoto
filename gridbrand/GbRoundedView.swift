//
//  GbBorderedButton.swift
//  gridbrand
//
//  Created by LionStar on 1/6/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbRoundedView: UIView {
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        
        layer.borderWidth = 1.0
        layer.borderColor = tintColor.cgColor
        layer.cornerRadius = bounds.size.height / 2.0
    }
}
