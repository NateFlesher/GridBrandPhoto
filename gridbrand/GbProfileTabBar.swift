//
//  GbMainTabBar.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

enum GbProfileTab {
    case cycle
    case star
    case note
    case profile
}

class GbProfileTabBar: GbCustomView {
    @IBOutlet weak var cycleTabBtn: UIButton!
    @IBOutlet weak var starTabBtn: UIButton!
    @IBOutlet weak var noteTabBtn: UIButton!
    @IBOutlet weak var profileTabBtn: UIButton!
    
    @IBOutlet weak var cycleTabWidth: NSLayoutConstraint!
    @IBOutlet weak var starTabWidth: NSLayoutConstraint!
    @IBOutlet weak var noteTabWidth: NSLayoutConstraint!
    @IBOutlet weak var profileTabWidth: NSLayoutConstraint!
    
    
    var tab = Variable(GbProfileTab.cycle)
    
    @IBAction func cycleTabTapped(_ sender: AnyObject) {
        self.activeTab(GbProfileTab.cycle)
    }
    
    @IBAction func starTabTapped(_ sender: AnyObject) {
        self.activeTab(GbProfileTab.star)
        
    }
    
    @IBAction func noteTabTapped(_ sender: AnyObject) {
        self.activeTab(GbProfileTab.note)
    }
    
    @IBAction func profileTabTapped(_ sender: AnyObject) {
        self.activeTab(GbProfileTab.profile)
    }
    
    public func activeTab(_ tab: GbProfileTab) {
        self.tab.value = tab
        
        self.cycleTabBtn.setImage(tab == GbProfileTab.cycle ? #imageLiteral(resourceName: "cycle_black") : #imageLiteral(resourceName: "cycle"), for: UIControlState.normal)
        self.starTabBtn.setImage(tab == GbProfileTab.star ? #imageLiteral(resourceName: "star_black") : #imageLiteral(resourceName: "star"), for: UIControlState.normal)
        self.noteTabBtn.setImage(tab == GbProfileTab.note ? #imageLiteral(resourceName: "note_black") : #imageLiteral(resourceName: "note"), for: UIControlState.normal)
        self.profileTabBtn.setImage(tab == GbProfileTab.profile ? #imageLiteral(resourceName: "profile_black") : #imageLiteral(resourceName: "profile"), for: UIControlState.normal)
    }
    
    public func setOuterUser(isOuterUser: Bool) {
        let bounds = self.bounds
        print(bounds)
        if isOuterUser {
            self.cycleTabWidth.constant = bounds.size.width/3
            self.starTabWidth.constant = 0
            self.noteTabWidth.constant = bounds.size.width/3
            self.profileTabWidth.constant = bounds.size.width/3
        } else {
            self.cycleTabWidth.constant = bounds.size.width/4
            self.starTabWidth.constant = bounds.size.width/4
            self.noteTabWidth.constant = bounds.size.width/4
            self.profileTabWidth.constant = bounds.size.width/4
        }
        self.setNeedsLayout()
    }
}
