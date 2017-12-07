//
//  GbElementColorToolView.swift
//  postcraft
//
//  Created by LionStar on 2/9/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbElementColorPatternPicker: GbCustomView {

    var selectedPattern:Any? = nil
    @IBOutlet weak var patternScrollView: UIScrollView!
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        self.perform(#selector(setupPatternScrollView), with: nil, afterDelay: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.perform(#selector(setupPatternScrollView), with: nil, afterDelay: 0.1)
    }
    
    func setupPatternScrollView() {
        let padding = 8
        let patternWidth = 56
        
        let size = CGSize(width:CGFloat(11*padding+10*patternWidth), height:patternScrollView.frame.height)
        patternScrollView.contentSize = size
        //patternScrollView.setContentOffset(CGPoint(x:0, y:0), animated:false)
        //patternScrollView.contentInset = .zero
        print("PatternScrollView ContentSize = \(NSStringFromCGSize(size))")
    }
    
}
