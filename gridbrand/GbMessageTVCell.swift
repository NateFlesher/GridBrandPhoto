//
//  GbMessageTVCell.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbMessageTVCell: UITableViewCell {
    static let Identifier = "MessageTVCell"
    
    @IBOutlet weak var avatarBtn: GbRoundedButton!
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var avatarButtonTapHandler: (((cell: GbMessageTVCell, sender: AnyObject)) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bindModel(model:MessageModel) {
        
        self.avatarBtn.setImage(nil, for: .normal)
        self.avatarBtn.setBackgroundImage(UIImage(named:(model.fromUser()?.avatar_url)!), for: .normal)
        self.nameLabel.text = model.fromUser()?.fullname
        self.messageLabel.text = model.message
        self.timeLabel.text = Date(timeIntervalSince1970:TimeInterval(model.created_time)).relativeTime
    }
    @IBAction func avatarBtnTapped(_ sender: AnyObject) {
        self.avatarButtonTapHandler?(self, sender)
    }
}
