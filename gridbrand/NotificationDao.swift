//
//  MessageDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class NotificationDao: BaseDao {
    
    let table = Table("tbl_notifications")
    
    let from_user_id =  Expression<Int64>("from_user_id")
    let to_user_id =  Expression<Int64>("to_user_id")
    let cycle_id =  Expression<Int64>("cycle_id")
    let note = Expression<String>("note")
    let type = Expression<String>("note")
    let read = Expression<Bool>("read")
    
    init() {
        super.init("tbl_notifications")
    }
    
    func findById(_ modelId:Int64)->NotificationModel? {
        if let item = super._findById(modelId) {
            return NotificationModel(data:item)
        }
        return nil        
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [NotificationModel] {
        let result = super._find(params)
        
        var models: [NotificationModel] = []
        for item in result {
            models.append(NotificationModel(data:item))
        }
        
        return models
    }
}
