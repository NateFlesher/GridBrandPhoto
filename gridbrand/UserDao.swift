//
//  UserDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class UserDao: BaseDao {
    
    let table = Table("tbl_users")
    
    let email = Expression<String>("email")
    let email_verified = Expression<Bool>("email_verified")
    let mobile = Expression<String>("mobile")
    let mobile_verified = Expression<Bool>("mobile_verified")
    let password = Expression<String>("password")
    let fullname = Expression<String>("fullname")
    let country = Expression<String>("country")
    let profession = Expression<String>("profession")
    let skype = Expression<String>("skype")
    let location = Expression<String>("location")
    let web = Expression<String>("web")
    let avatar_url = Expression<String>("avatar_url")
    let cover_url = Expression<String>("cover_url")
    let note = Expression<String>("note")
    let money_amount = Expression<Double>("money_amount")
    let cycle_amount = Expression<Double>("cycle_amount")
    let reset_password_status = Expression<Int64>("reset_password_status")
    
    init() {
        super.init("tbl_users")
    }
    
    
    func findById(_ modelId:Int64)->UserModel? {
        if let item = super._findById(modelId) {
            return UserModel(data:item)
        }
        return nil        
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [UserModel] {
        let result = super._find(params)
        
        var models: [UserModel] = []
        for item in result {
            models.append(UserModel(data:item))
        }
        
        return models
    }
}
