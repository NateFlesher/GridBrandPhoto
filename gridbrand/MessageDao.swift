//
//  MessageDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class MessageDao: BaseDao {
    
    let table = Table("tbl_messages")
    
    let from_user_id =  Expression<Int64>("from_user_id")
    let to_user_id =  Expression<Int64>("to_user_id")
    let message = Expression<String>("message")
    let deleted = Expression<Bool>("deleted")
    let updated = Expression<Bool>("updated")
    
    init() {
        super.init("tbl_messages")
    }
    
    func findById(_ modelId:Int64)->MessageModel? {
        if let item = super._findById(modelId) {
            return MessageModel(data:item)
        }
        return nil        
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [MessageModel] {
        let result = super._find(params)
        
        var models: [MessageModel] = []
        for item in result {
            models.append(MessageModel(data:item))
        }
        
        return models
    }
}
