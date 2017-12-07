//
//  GbCycleCVCell.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

@IBDesignable class GbCycleCVCell: UICollectionViewCell {
    static let Identifier = "CycleCVCell"
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var avatarBtn: GbRoundedButton!
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var alertView: UIView!
    
    var model: CycleModel? = nil

    var photoImageTapHandler: ((_ cell: GbCycleCVCell) -> Void)? = nil
    var moreButtonTapHandler: ((_ cell: GbCycleCVCell, _ sender: AnyObject) -> Void)? = nil
    var avatarButtonTapHandler: ((_ cell: GbCycleCVCell, _ sender: AnyObject) -> Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1.0).cgColor
        
        alertView.layer.cornerRadius = 5
        
        
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(photoImageTapped)))
        
    }

    func bindModel(model:CycleModel) {
        self.photoImageView.image = UIImage(named: model.photo_url)
        
        self.avatarBtn.setImage(nil, for: .normal)
        self.avatarBtn.setBackgroundImage(UIImage(named:model.user().avatar_url), for: .normal)
        
        if(model.price_unit == CyclePriceUnit.dollar.rawValue) {
            self.typeImageView.image = #imageLiteral(resourceName: "dollar")
        } else if(model.price_unit == CyclePriceUnit.cycle.rawValue) {
            self.typeImageView.image = #imageLiteral(resourceName: "cycle_green")
        }
        
        self.priceLabel.text = "\(model.price)"
        
        self.alertView.isHidden = !model.counting
        self.model = model
        
    }
    
    @IBAction func moreBtnTapped(_ sender: AnyObject) {
        self.moreButtonTapHandler?(self, sender)
    }
    @IBAction func avatarBtnTapped(_ sender: AnyObject) {
        self.avatarButtonTapHandler?(self, sender)
    }
    
    func photoImageTapped(recognizer: UITapGestureRecognizer) {
        self.photoImageTapHandler?(self)
    }
}
