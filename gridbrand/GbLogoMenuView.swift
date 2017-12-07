//
//  GbLogoMenuView.swift
//  postcraft
//
//  Created by LionStar on 2/7/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbLogoMenu {
    case multiply
    case overlay
    case hue
    case softLight
}
protocol GbLogoMenuViewDelegate {
    func didSelectedMenu(menu:GbLogoMenu, sender: Any)
}


class GbLogoMenuView: GbCustomView {
    var delegate: GbLogoMenuViewDelegate? = nil
    var logoImage: UIImage? = nil

    @IBOutlet weak var logoImageView: GbRoundedImageView!
    @IBOutlet weak var multiplyBtn: GbRoundedButton!
    @IBOutlet weak var overlayBtn: GbRoundedButton!
    @IBOutlet weak var hueBtn: GbRoundedButton!
    @IBOutlet weak var softLightBtn: GbRoundedButton!
    
    @IBAction func logoUploadBtnTapped(_ sender: Any) {
        
    }
    @IBAction func multiplyBtnTapped(_ sender: Any) {
        selectMenu(menu:.multiply, sender:sender)
    }
    @IBAction func overlayBtnTapped(_ sender: Any) {
        selectMenu(menu:.overlay, sender:sender)
    }
    @IBAction func hueBtnTapped(_ sender: Any) {
        selectMenu(menu:.hue, sender:sender)
    }
    @IBAction func softLightBtnTapped(_ sender: Any) {
        selectMenu(menu:.softLight, sender:sender)
    }
    
    @IBAction func buyLogoBtnTapped(_ sender: Any) {
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func selectMenu(menu:GbLogoMenu, sender:Any) {
        self.delegate?.didSelectedMenu(menu:menu, sender:sender)
        
        self.multiplyBtn.backgroundColor = menu == .multiply ? GbColor.purple : UIColor.white
        self.multiplyBtn.setTitleColor(menu == .multiply ? UIColor.white : GbColor.darkGray, for: .normal)
        
        self.overlayBtn.backgroundColor = menu == .overlay ? GbColor.purple : UIColor.white
        self.overlayBtn.setTitleColor(menu == .overlay ? UIColor.white : GbColor.darkGray, for: .normal)
        
        self.hueBtn.backgroundColor = menu == .hue ? GbColor.purple : UIColor.white
        self.hueBtn.setTitleColor(menu == .hue ? UIColor.white : GbColor.darkGray, for: .normal)
        
        self.softLightBtn.backgroundColor = menu == .softLight ? GbColor.purple : UIColor.white
        self.softLightBtn.setTitleColor(menu == .softLight ? UIColor.white : GbColor.darkGray, for: .normal)
    }
}
