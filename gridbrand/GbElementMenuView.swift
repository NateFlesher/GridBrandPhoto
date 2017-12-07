//
//  GbElementMenuView.swift
//  postcraft
//
//  Created by LionStar on 2/7/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbElementMenu {
    case color
    case filter
    case blending
    case shadow
}
protocol GbElementMenuViewDelegate {
    func didSelectedMenu(menu:GbElementMenu, sender: Any)
}

class GbElementMenuView: GbCustomView {
    var delegate: GbElementMenuViewDelegate? = nil
    
    @IBOutlet weak var colorBtn: GbIconButton!
    @IBOutlet weak var filterBtn: GbIconButton!
    @IBOutlet weak var blendingBtn: GbIconButton!
    @IBOutlet weak var shadowBtn: GbIconButton!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        setButtonHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setButtonHandler()
    }
    
    func setButtonHandler() {
        
        colorBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.color, sender:sender)
        }
        filterBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.filter, sender:sender)
        }
        blendingBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.blending, sender:sender)
        }
        shadowBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.shadow, sender:sender)
        }
    }
}
