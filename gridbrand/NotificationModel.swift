//
//  MessageModel.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation

enum NotificationType: Int64 {
    case none = 0
    case recycle = 1
    case buy = 2
    case follow = 3
}

public class NotificationModel: BaseModel {
    public var from_user_id: Int64 = 0
    public var to_user_id: Int64 = 0
    public var type: Int64 = NotificationType.none.rawValue        // notification type(1: Recycle, 2: Buy, 3: Follow)
    public var note: String = ""
    var cycle_id: Int64 = 0
    var read: Bool = false
    
    public override init() {
        super.init()
    }
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.from_user_id = DataConverter.toInt64(data["from_user_id"])
        self.to_user_id = DataConverter.toInt64(data["to_user_id"])
        self.cycle_id = DataConverter.toInt64(data["cycle_id"])
        self.type = DataConverter.toInt64(data["type"])
        self.note = data["note"] as! String? ?? ""
        self.read = DataConverter.toBool(data["read"])
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["from_user_id"] = from_user_id
        dict["to_user_id"] = to_user_id
        dict["cycle_id"] = cycle_id
        dict["type"] = type
        dict["note"] = note
        dict["read"] = read
        
        return dict
    }
    
    func fromUser()->UserModel? {
        let userDao = UserDao()
        
        return userDao.findById(from_user_id)
    }
    
    func cycle()->CycleModel? {
        if cycle_id == 0 {
            return nil
        }
        return CycleDao().findById(cycle_id)
    }
}
