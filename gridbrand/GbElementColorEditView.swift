//
//  GbElementColorEditView.swift
//  postcraft
//
//  Created by LionStar on 2/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbColorType {
    case solid
    case gradient
    case pattern
}
class GbElementColorEditView: GbCustomView {
    var parentPopup: KLCPopup? = nil
    var acceptHandler: ((_ obj:Any?)->Void)? = nil
    
    var colorType: GbColorType = .solid
    
    
    @IBOutlet weak var gradientPicker: GbElementColorGradientPicker!
    @IBOutlet weak var solidPicker: GbElementColorSolidPicker!
    @IBOutlet weak var patternPicker: GbElementColorPatternPicker!
    
    @IBOutlet weak var solidBtn: UIButton!
    @IBOutlet weak var gradientBtn: UIButton!
    @IBOutlet weak var patternBtn: UIButton!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        selectColorType(type: .solid)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectColorType(type: .solid)
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        parentPopup?.dismiss(true)
    }
    
    @IBAction func acceptBtnTapped(_ sender: Any) {
        parentPopup?.dismiss(true)
        parentPopup?.didFinishDismissingCompletion = {
            switch self.colorType {
            case .solid:
                self.acceptHandler?(self.solidPicker.selectedColor)
            case .gradient:
                self.acceptHandler?(self.gradientPicker.selectedGradientLayer)
            case .pattern:
                self.acceptHandler?(self.patternPicker.selectedPattern)
            }
        }
    }
    
    @IBAction func solidBtnTapped(_ sender: Any) {
        selectColorType(type: .solid)
    }
    @IBAction func gradientBtnTapped(_ sender: Any) {
        selectColorType(type: .gradient)
    }
    @IBAction func patternBtnTapped(_ sender: Any) {
        selectColorType(type: .pattern)
    }
    
    func selectColorType(type:GbColorType) {
        colorType = type
        
        solidBtn.setTitleColor(type == .solid ? UIColor.white : UIColor(white:1.0, alpha:0.59), for: .normal)
        gradientBtn.setTitleColor(type == .gradient ? UIColor.white : UIColor(white:1.0, alpha:0.59), for: .normal)
        patternBtn.setTitleColor(type == .pattern ? UIColor.white : UIColor(white:1.0, alpha:0.59), for: .normal)
        
        solidPicker.isHidden = type != .solid
        gradientPicker.isHidden = type != .gradient
        patternPicker.isHidden = type != .pattern
    }
    
}
