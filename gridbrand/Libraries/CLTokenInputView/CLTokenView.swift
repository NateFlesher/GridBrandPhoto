//
//  CLTokenView.swift
//  CLTokenInputView
//
//  Created by Robert La Ferla on 1/13/16 from original ObjC version by Rizwan Sattar.
//  Copyright © 2016 Robert La Ferla. All rights reserved.
//

import Foundation
import UIKit

protocol CLTokenViewDelegate {
    func tokenViewDidRequestDelete(_ tokenView:CLTokenView, replaceWithText replacementText:String?)
    func tokenViewDidRequestSelection(_ tokenView:CLTokenView)
}

class CLTokenView: UIView, UIKeyInput {
    var delegate: CLTokenViewDelegate?
    var selected: Bool! {
        didSet {
            if oldValue != self.selected {
                self.setSelectedNoCheck(self.selected, animated: false)
            }
        }
    }
    var hideUnselectedComma: Bool! {
        didSet {
            if oldValue != self.hideUnselectedComma {
                self.updateLabelAttributedText()
            }
        }
    }
    
    var backgroundView:UIView?
    var label:UILabel!
    var selectedBackgroundView:UIView!
    var selectedLabel:UILabel!
    var displayText:String!
    
    let PADDING_X = 4.0
    let PADDING_Y = 2.0
//    let UNSELECTED_LABEL_FORMAT = "%@, "
//    let UNSELECTED_LABEL_NO_COMMA_FORMAT = "%@"
    
    init(frame:CGRect, token: CLToken, font:UIFont?) {
        super.init(frame: frame)
        let tintColor:UIColor = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1.0)
        //self.tintColor = tintColor
        self.label = UILabel(frame: CGRect(x: PADDING_X, y: PADDING_Y, width: 0.0, height: 0.0))
        if font != nil {
            self.label.font = font
        }
        self.label.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
        self.label.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        self.label.textAlignment = .center
        self.addSubview(label)
        
        self.selectedBackgroundView = UIView(frame: CGRect.zero)
        self.selectedBackgroundView.backgroundColor = tintColor
        self.selectedBackgroundView.layer.cornerRadius = 3.0
        self.addSubview(self.selectedBackgroundView)
        self.selectedBackgroundView.isHidden = true
        
        self.selectedLabel = UILabel(frame: CGRect(x: PADDING_X, y: PADDING_Y, width: 0.0, height: 0.0))
        self.selectedLabel.font = self.label.font
        self.selectedLabel.textAlignment = .center
        self.selectedLabel.textColor = UIColor.white
        self.selectedLabel.backgroundColor = UIColor.clear
        self.addSubview(self.selectedLabel)
        self.selectedLabel.isHidden = true
        
        self.selected = false
        
        self.displayText = token.displayText
        self.hideUnselectedComma = true
        self.updateLabelAttributedText()
        self.selectedLabel.text = token.displayText
        let tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CLTokenView.handleTapGestureRecognizer(_:)))
        self.addGestureRecognizer(tapRecognizer)
        self.setNeedsLayout()
    }

    convenience init(token: CLToken, font:UIFont?) {
        self.init(frame: CGRect.zero, token: token, font: font)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var intrinsicContentSize: CGSize {
        get {
            let labelIntrinsicSize:CGSize = self.selectedLabel.intrinsicContentSize
            return CGSize(width: Double(labelIntrinsicSize.width + 10)+(2.0*PADDING_X), height: Double(labelIntrinsicSize.height + 12)+(2.0*PADDING_Y))
        }
    }
    
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fittingSize = CGSize(width: Double(size.width)-(2.0*PADDING_X), height:Double(size.height)-(2.0*PADDING_Y))
        let labelSize = self.selectedLabel.sizeThatFits(fittingSize)
        return CGSize(width: Double(labelSize.width)+(2.0*PADDING_X), height:Double(labelSize.height)+(2.0*PADDING_Y))
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        self.label.textColor = tintColor
        self.selectedBackgroundView.backgroundColor = tintColor
        self.updateLabelAttributedText()
    }
    
    
    func handleTapGestureRecognizer(_ sender:UIGestureRecognizer) {
        self.delegate?.tokenViewDidRequestSelection(self)
    }
    
    func setSelected(_ selectedBool:Bool, animated:Bool) {
        if (self.selected == selectedBool) {
            return
        }
        
        self.selected = selectedBool
        
        self.setSelectedNoCheck(selectedBool, animated: animated)
    }
    
    func setSelectedNoCheck(_ selectedBool:Bool, animated:Bool) {
        if selectedBool == true && !self.isFirstResponder {
            _ = self.becomeFirstResponder()
        }
        else if !selectedBool && self.isFirstResponder {
            _ = self.resignFirstResponder()
        }
        
        var selectedAlpha:CGFloat = 0.0
        if selectedBool == true {
            selectedAlpha = 1.0
        }
        
        if animated == true {
            if self.selected == true {
                self.selectedBackgroundView.alpha = 0.0
                self.selectedBackgroundView.isHidden = false
                self.selectedLabel.alpha = 0.0
                self.selectedLabel.isHidden = false
            }
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                self.selectedBackgroundView.alpha = selectedAlpha
                self.selectedLabel.alpha = selectedAlpha
                }, completion: { (finished:Bool) -> Void in
                    if (!self.selected) {
                        self.selectedBackgroundView.isHidden = true
                        self.selectedLabel.isHidden = true
                    }
            })
        }
        else {
            self.selectedBackgroundView.isHidden = !self.selected
            self.selectedLabel.isHidden = !self.selected
        }
    }
    
    func updateLabelAttributedText() {
        var labelString:String!

        if self.hideUnselectedComma == true {
            labelString = "\(displayText!)"
        }
        else {
            labelString = "\(displayText!)"
        }
        
        let attributes = [ NSFontAttributeName: self.label.font, NSForegroundColorAttributeName: UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)] as [String : Any]
        let attrString = NSMutableAttributedString(string: labelString, attributes: attributes)
        
        let tintRange = (labelString as NSString).range(of: self.displayText)
        
        attrString.setAttributes(attributes, range: tintRange)
        self.label.attributedText = attrString        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds:CGRect = self.bounds
        
        self.backgroundView?.frame = bounds
        
        var labelFrame = bounds.insetBy(dx: CGFloat(PADDING_X), dy: CGFloat(PADDING_Y))
        labelFrame.size.width += CGFloat(PADDING_X * 2.0)
        self.selectedBackgroundView.frame = labelFrame
        self.selectedBackgroundView.layer.cornerRadius = self.selectedBackgroundView.frame.size.height / 2
        self.selectedLabel.frame = labelFrame
        
        self.label.frame = labelFrame
        self.label.layer.masksToBounds = true
        self.label.layer.cornerRadius = self.label.frame.size.height / 2
    }
    
    
    var hasText: Bool {
        get {
            return true
        }
    }
    
    func insertText(_ text: String) {
         self.delegate?.tokenViewDidRequestDelete(self, replaceWithText: text)
    }
    
    func deleteBackward() {
         self.delegate?.tokenViewDidRequestDelete(self, replaceWithText: nil)
    }
    
    override var canBecomeFirstResponder: Bool { get {
        return true
        }
    }
    
    override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        self.setSelected(false, animated: false)
        return didResignFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        self.setSelected(true, animated: false)
        return didBecomeFirstResponder
    }
    
    
}
