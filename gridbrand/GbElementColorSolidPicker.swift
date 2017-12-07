//
//  GbElementColorSolidToolView.swift
//  postcraft
//
//  Created by LionStar on 2/9/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbElementColorSolidPicker: GbCustomView {

    var selectedColor:UIColor? = nil

    @IBOutlet weak var hueSlider: GbHueSlider!
    @IBOutlet weak var brightnessSlider: GbBrightnessSlider!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.hueSlider.delegate = self
        self.brightnessSlider.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        
        self.hueSlider.delegate = self
        self.brightnessSlider.delegate = self
    }
}



extension GbElementColorSolidPicker:GbHueSliderDelegate, GbBrightnessSliderDelegate{
    func hueSlider(_ slider:GbHueSlider, didSelectColor color:UIColor, hue:CGFloat) {
        self.brightnessSlider.hue = hue
    }
    
    func brightnessSlider(_ slider: GbBrightnessSlider, didSelectBrightness brightness: CGFloat, saturation: CGFloat) {
        print("\(brightness):\(saturation)")
    }
}
