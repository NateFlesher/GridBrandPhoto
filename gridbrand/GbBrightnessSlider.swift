//
//  GbBrightnessSlider.swift
//  postcraft
//
//  Created by LionStar on 2/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

internal protocol GbBrightnessSliderDelegate : NSObjectProtocol {
    func brightnessSlider(_ slider:GbBrightnessSlider, didSelectBrightness brightness:CGFloat, saturation:CGFloat)
}

@IBDesignable class GbBrightnessSlider: UIView {
    weak internal var delegate: GbBrightnessSliderDelegate?
    
    let saturationExponentLeft:Float = 2.0
    let saturationExponentRight:Float = 1.3
    
    
    
    let bubbleLength:CGFloat = 25.0
    
    weak var colorBubbleView: UIView?
    
    @IBInspectable var saturation:CGFloat = 0.0 {
        didSet {
            let point = self.getPointForSaturation(saturation, brightness: brightness)
            
            self.colorBubbleView?.center = point
            self.colorBubbleView?.backgroundColor = UIColor(hue:hue, saturation:saturation, brightness:brightness, alpha:1.0)
        }
    }
    
    @IBInspectable var brightness:CGFloat = 0.0 {
        didSet {
            let point = self.getPointForSaturation(saturation, brightness: brightness)
            
            self.colorBubbleView?.center = point
            self.colorBubbleView?.backgroundColor = UIColor(hue:hue, saturation:saturation, brightness:brightness, alpha:1.0)
        }
    }
    
    @IBInspectable var hue: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
            self.colorBubbleView?.backgroundColor = UIColor(hue:hue, saturation:saturation, brightness:brightness, alpha:1.0)
        }
    }
    
    private func initialize() {
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
        _colorBubbleView.backgroundColor = self.getColor()
        
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
        
        
        self.saturation = self.getSaturationAtPoint(point)
        self.brightness = self.getBrightnessAtPoint(point)
        
        self.delegate?.brightnessSlider(self, didSelectBrightness: self.brightness, saturation: self.saturation)
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
            
            var saturation = x < rect.width / 2.0 ? CGFloat(2 * x) / rect.width : 2.0 * CGFloat(rect.width - x) / rect.width
            saturation = CGFloat(powf(Float(saturation), x < rect.width / 2.0 ? saturationExponentLeft : saturationExponentRight))
            let brightness = x < rect.width / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.width - x) / rect.width
            
            let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
            
            context!.setFillColor(color.cgColor)
            context!.fill(CGRect(x:x, y:0, width:1.0, height:rect.height))
        }
    }
    
    func getColor() -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func getBrightnessAtPoint(_ point:CGPoint) -> CGFloat {
        let brightness = point.x < self.bounds.width / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.width - point.x) / self.bounds.width
        
        return brightness
    }
    
    
    func getSaturationAtPoint(_ point:CGPoint) -> CGFloat {
        var saturation = point.x < self.bounds.width / 2.0 ? CGFloat(2 * point.x) / self.bounds.width : 2.0 * CGFloat(self.bounds.width - point.x) / self.bounds.width
        saturation = CGFloat(powf(Float(saturation), point.x < self.bounds.width / 2.0 ? saturationExponentLeft : saturationExponentRight))
        
        return saturation
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue:CGFloat=0;
        var saturation:CGFloat=0;
        var brightness:CGFloat=0;
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var xPos:CGFloat = 0
        let halfWidth = (self.bounds.width / 2)
        
        if (brightness >= 0.99) {
            let percentageX = powf(Float(saturation), 1.0 / saturationExponentLeft)
            xPos = CGFloat(percentageX) * halfWidth
        } else {
            //use brightness to get Y
            xPos = halfWidth + halfWidth * (1.0 - brightness)
        }

        
        return CGPoint(x: xPos, y: self.bounds.height/2.0)
    }
    
    
    func getPointForSaturation(_ sat:CGFloat, brightness bright:CGFloat) -> CGPoint {
        
        var xPos:CGFloat = 0
        let halfWidth = (self.bounds.width / 2)
        
        if (bright >= 0.99) {
            let percentageX = powf(Float(sat), 1.0 / saturationExponentLeft)
            xPos = CGFloat(percentageX) * halfWidth
        } else {
            //use brightness to get Y
            xPos = halfWidth + halfWidth * (1.0 - bright)
        }
        
        
        return CGPoint(x: xPos, y: self.bounds.height/2.0)
    }

}
