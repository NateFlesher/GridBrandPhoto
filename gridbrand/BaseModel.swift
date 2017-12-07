//
//  BaseModel.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation

public class BaseModel {
    var id: Int64 = 0
    
    var created_time: Int64 = 0
    var updated_time: Int64 = 0
    
    init() {}
    init(data:Dictionary<String, Any>){
        self.id = DataConverter.toInt64(data["id"])
        
        self.created_time = DataConverter.toInt64(data["created_time"])
        self.updated_time = DataConverter.toInt64(data["updated_time"])        
    }
    
    public func toDictionary()->Dictionary<String, Any> {
        return [
            "id": id,
            "created_time": created_time,
            "updated_time": updated_time
        ]
    }
}
