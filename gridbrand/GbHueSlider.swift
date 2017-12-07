//
//  GbHueSlider.swift
//  postcraft
//
//  Created by LionStar on 2/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

protocol GbHueSliderDelegate : NSObjectProtocol {
    func hueSlider(_ slider:GbHueSlider, didSelectColor color:UIColor, hue:CGFloat)
}


@IBDesignable class GbHueSlider: UIView {
    var delegate: GbHueSliderDelegate?
    
    let bubbleLength:CGFloat = 25.0
    
    weak var colorBubbleView: UIView?
    
    @IBInspectable var color:UIColor?=UIColor.yellow {
        didSet {
            let point = self.getPointForColor(color: color!)
            
            self.colorBubbleView?.center = point
            self.colorBubbleView?.backgroundColor = color!
        }
    }
    
    private func initialize() {
        
        //self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchHandler(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
        
        let bubbleBorderColor = UIColor(white:0.9, alpha:0.8)
        
        let _colorBubbleView = UIView(frame: CGRect(x:100, y:(self.bounds.height-bubbleLength)/2.0, width:bubbleLength, height:bubbleLength))
        _colorBubbleView.layer.cornerRadius = bubbleLength / 2.0
        _colorBubbleView.layer.borderWidth = 2
        _colorBubbleView.layer.borderColor = bubbleBorderColor.cgColor
        _colorBubbleView.layer.shadowColor = UIColor.black.cgColor
        _colorBubbleView.layer.shadowOffset = CGSize.zero
        _colorBubbleView.layer.shadowRadius = 1
        _colorBubbleView.layer.shadowOpacity = 0.5
        _colorBubbleView.layer.shouldRasterize = true
        _colorBubbleView.layer.rasterizationScale = UIScreen.main.scale
        _colorBubbleView.clipsToBounds = false
        
        self.addSubview(_colorBubbleView)
        self.colorBubbleView = _colorBubbleView
    }
    
    
    func touchHandler(gestureRecognizer: UILongPressGestureRecognizer){
        var point = gestureRecognizer.location(in: self)
        
        if point.x < 0 {
            point.x = 0
        }
        if point.x > self.bounds.width {
            point.x = self.bounds.width
        }
        if point.y < 0 {
            point.y = 0
        }
        if point.y > self.bounds.height {
            point.y = self.bounds.height
        }
        
        
        self.color = getColorAtPoint(point: point)
        
        self.delegate?.hueSlider(self, didSelectColor: self.color!, hue:point.x/self.bounds.width)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for x in stride(from:(0 as CGFloat), to:rect.width, by:1.0) {
            let hue = x / rect.width
            
            let color = UIColor(hue:hue, saturation:1.0, brightness:1.0, alpha:1.0)
            
            context!.setFillColor(color.cgColor)
            context!.fill(CGRect(x:x, y:0, width:1.0, height:rect.height))
        }
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let hue = point.x / self.bounds.width
        return UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        let xPos = hue * self.bounds.width
        
        return CGPoint(x: xPos, y: self.bounds.height/2.0)
    }
}
