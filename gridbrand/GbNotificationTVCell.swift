//
//  GbMessageTVCell.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbNotificationTVCell: UITableViewCell {
    static let Identifier = "NotificationTVCell"
    
    @IBOutlet weak var avatarBtn: GbRoundedButton!
    @IBOutlet weak var thumbnailBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbnailWidth: NSLayoutConstraint!
    
    
    var avatarButtonTapHandler: (((cell: GbNotificationTVCell, sender: AnyObject)) -> Void)? = nil
    var thumbnailButtonTapHandler: (((cell: GbNotificationTVCell, sender: AnyObject)) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bindModel(model:NotificationModel) {
        self.avatarBtn.setImage(nil, for: .normal)
        self.avatarBtn.setBackgroundImage(UIImage(named:(model.fromUser()?.avatar_url)!), for: .normal)
        
        self.nameLabel.text = model.fromUser()?.fullname
        
        var message: String? = nil
        
        self.thumbnailBtn.setImage(nil, for: .normal)
        switch(model.type) {
        case NotificationType.buy.rawValue:
            thumbnailWidth.constant = 26
            self.thumbnailBtn.setBackgroundImage(UIImage(named:(model.cycle()?.photo_url)!), for: .normal)
            message = "buy your post"
        case NotificationType.recycle.rawValue:
            thumbnailWidth.constant = 26
            self.thumbnailBtn.setBackgroundImage(UIImage(named:(model.cycle()?.photo_url)!), for: .normal)
            message = "recycling your post"
        case NotificationType.follow.rawValue:
            thumbnailWidth.constant = 0
            message = "started following you"
        default:
            thumbnailWidth.constant = 0
        }
        self.messageLabel.text = message
        self.timeLabel.text = Date(timeIntervalSince1970:TimeInterval(model.created_time)).relativeTime
    }
    @IBAction func avatarBtnTapped(_ sender: AnyObject) {
        self.avatarButtonTapHandler?(self, sender)
    }
    @IBAction func thumbnailBtnTapped(_ sender: AnyObject) {
        self.thumbnailButtonTapHandler?(self, sender)
    }
}
