//
//  GbEditToolbar.swift
//  postcraft
//
//  Created by LionStar on 2/7/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbEditToolbar: GbCustomView {
    var editMainMenu:GbPhotoEditMainMenu? = nil
    
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var maskBtn: UIButton!
    @IBOutlet weak var textBtn: UIButton!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var elementLabel: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    
    @IBOutlet weak var maskBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textBtnWidthConstraint: NSLayoutConstraint!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setEditMainMenu(menu:GbPhotoEditMainMenu) {
        switch menu {
        case .logo:
            self.view.backgroundColor = GbColor.purple
            self.textBtnWidthConstraint.constant = 0.0
            self.maskBtnWidthConstraint.constant = 24.0
        case .element:
            self.view.backgroundColor = GbColor.green
            self.textBtnWidthConstraint.constant = 0.0
            self.maskBtnWidthConstraint.constant = 24.0
        case .font:
            self.view.backgroundColor = GbColor.blue
            self.textBtnWidthConstraint.constant = 24.0
            self.maskBtnWidthConstraint.constant = 0.0
        case .search:
            self.view.backgroundColor = GbColor.green
            self.textBtnWidthConstraint.constant = 0.0
            self.maskBtnWidthConstraint.constant = 24.0
        }
        
        UIView.animate(withDuration: 0.1) { 
            self.layoutIfNeeded()
        }
    }
}
