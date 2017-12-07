//
//  GbCraftCycleView.swift
//  postcraft
//
//  Created by LionStar on 2/6/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbCraftCycleView: GbCustomView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var avatarImageView: GbRoundedImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    var closeBtnTapHandler: ((_ sender: Any) -> Void)? = nil
    var craftBtnTapHandler: ((_ sender: Any) -> Void)? = nil
    
    init(frame: CGRect, cycle:CycleModel) {
        super.init(frame: frame)
        backgroundView.addBlurEffect()
        photoImageView.layer.cornerRadius = 6
        photoImageView.clipsToBounds = true
        
        
        let user = cycle.user()
        avatarImageView.image = UIImage(named:user.avatar_url)
        usernameLabel.text = user.fullname
        photoImageView.image = UIImage(named:cycle.photo_url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.closeBtnTapHandler?(sender)
    }
    @IBAction func craftBtnTapped(_ sender: Any) {
        self.craftBtnTapHandler?(sender)
    }
}
