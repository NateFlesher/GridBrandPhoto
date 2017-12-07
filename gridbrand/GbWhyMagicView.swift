//
//  GbWhyMagicView.swift
//  postcraft
//
//  Created by LionStar on 1/26/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbWhyMagicView: GbCustomView {

    var parentPopup: KLCPopup? = nil
    
    var completionHandler: (() -> Void)? = nil

    @IBAction func greatBtnTapped(_ sender: AnyObject) {
        parentPopup?.dismiss(true)
        parentPopup?.didFinishDismissingCompletion = {
            self.completionHandler?()
        }
    }
}
