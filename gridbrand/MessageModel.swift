//
//  MessageModel.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation

public class MessageModel: BaseModel {
    
    public var from_user_id: Int64 = 0
    public var to_user_id: Int64 = 0
    public var message: String = ""
    public var deleted: Bool = false
    public var updated: Bool = false
    
    
    public override init() {
        super.init()
    }
    
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.from_user_id = DataConverter.toInt64(data["from_user_id"])
        self.to_user_id = DataConverter.toInt64(data["to_user_id"])
        self.message = data["message"] as! String? ?? ""
        self.deleted = DataConverter.toBool(data["deleted"])
        self.updated = DataConverter.toBool(data["updated"])
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["from_user_id"] = from_user_id
        dict["to_user_id"] = to_user_id
        dict["message"] = message
        dict["deleted"] = deleted
        dict["updated"] = updated
        
        return dict
    }
    
    func fromUser()->UserModel? {
        let userDao = UserDao()
        
        return userDao.findById(self.from_user_id)
    }
}
