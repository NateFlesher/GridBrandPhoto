//
//  GbProfileView.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbProfileView: GbCustomView {

    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var skypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var webLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var professionEditBtn: UIButton!
    @IBOutlet weak var skypeEditBtn: UIButton!
    @IBOutlet weak var locationEditBtn: UIButton!
    @IBOutlet weak var webEditBtn: UIButton!
    @IBOutlet weak var noteEditBtn: UIButton!
    
    
    func bindData(_ user:UserModel) {
        professionLabel.text = user.profession
        mailLabel.text = user.email
        skypeLabel.text = user.skype
        locationLabel.text = user.location
        webLabel.text = user.web
        noteLabel.text = user.note
        
        let isOuterUser = user.id != AppSession.currentUser?.id
        
        self.professionEditBtn.isHidden = isOuterUser
        self.skypeEditBtn.isHidden = isOuterUser
        self.locationEditBtn.isHidden = isOuterUser
        self.webEditBtn.isHidden = isOuterUser
        self.noteEditBtn.isHidden = isOuterUser
    }
    
}
