//
//  GbPopupContentView.swift
//  postcraft
//
//  Created by LionStar on 1/20/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbPopupContentView: UIView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews as [UIView] {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
