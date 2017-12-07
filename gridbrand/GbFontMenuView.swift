//
//  GbFontMenuView.swift
//  postcraft
//
//  Created by LionStar on 2/7/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbFontMenu {
    case style
    case font
    case size
    case alignment
}
protocol GbFontMenuViewDelegate {
    func didSelectedMenu(menu:GbFontMenu, sender: Any)
}

class GbFontMenuView: GbCustomView {
    var delegate: GbFontMenuViewDelegate? = nil

    @IBOutlet weak var styleBtn: GbIconButton!
    @IBOutlet weak var fontBtn: GbIconButton!
    @IBOutlet weak var sizeBtn: GbIconButton!
    @IBOutlet weak var alignmentBtn: GbIconButton!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        setButtonHandler()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButtonHandler()
    }

    func setButtonHandler() {
        
        styleBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.style, sender:sender)
        }
        fontBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.font, sender:sender)
        }
        sizeBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.size, sender:sender)
        }
        alignmentBtn.btnTapHandler = {sender in
            self.delegate?.didSelectedMenu(menu:.alignment, sender:sender)
        }
    }
}
