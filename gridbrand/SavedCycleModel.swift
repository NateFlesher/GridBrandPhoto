//
//  CycleModel.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

public class SavedCycleModel: BaseModel {
    
    public var user_id: Int64 = 0
    public var cycle_id: Int64 = 0
    
    
    public override init() {
        super.init()
    }
    
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.user_id = DataConverter.toInt64(data["user_id"])
        self.cycle_id = DataConverter.toInt64(data["cycle_id"])
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["user_id"] = user_id
        dict["cycle_id"] = cycle_id
        
        return dict
    }
    
    func user()->UserModel {
        return UserDao().findById(user_id)!
    }
    
    func cycle()->CycleModel {
        return CycleDao().findById(cycle_id)!
    }
}
