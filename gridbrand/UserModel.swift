//
//  UserModel.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation

public class UserModel: BaseModel {    
    public var email: String = ""
    public var email_verified: Bool = false
    
    public var mobile: String = ""
    public var mobile_verified: Bool = false
    
    public var fullname: String = ""
    public var country: String = ""
    public var profession: String = ""
    public var skype: String = ""
    public var location: String = ""
    public var web: String = ""
    public var avatar_url: String = ""
    public var cover_url: String = ""
    public var note: String = ""
    public var money_amount: Double = 0
    public var cycle_amount: Double = 0
    
    public var reset_password_status: Int64 = 0 // 0: Normal, 1: Flaged as reset password, 2: Verified reset password

    public var cycles: [CycleModel] = []
    public var followers: [UserModel] = []
    
    public override init() {
        super.init()
    }
    
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.email = data["email"] as! String? ?? ""
        self.email_verified = DataConverter.toBool(data["email_verified"])
        
        self.mobile = data["mobile"] as! String? ?? ""
        self.mobile_verified = DataConverter.toBool(data["mobile_verified"])
        
        self.fullname = data["fullname"] as! String? ?? ""
        self.country = data["country"] as! String? ?? ""
        self.profession = data["profession"] as! String? ?? ""
        self.skype = data["skype"] as! String? ?? ""
        self.location = data["location"] as! String? ?? ""
        self.web = data["web"] as! String? ?? ""
        self.avatar_url = data["avatar_url"] as! String? ?? ""
        self.cover_url = data["cover_url"] as! String? ?? ""
        self.note = data["note"] as! String? ?? ""
        
        self.money_amount = DataConverter.toDouble(data["money_amount"])
        self.cycle_amount = DataConverter.toDouble(data["cycle_amount"])
        self.reset_password_status = DataConverter.toInt64(data["reset_password_status"])
        
        self.cycles = []
        self.followers = []
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["email"] = email
        dict["fullname"] = fullname
        dict["country"] = country
        dict["profession"] = profession
        dict["skype"] = skype
        dict["location"] = location
        dict["web"] = web
        dict["avatar_url"] = avatar_url
        dict["cover_url"] = cover_url
        dict["note"] = note
        dict["money_amount"] = money_amount
        dict["cycle_amount"] = cycle_amount
    
        return dict
    }
    
}
