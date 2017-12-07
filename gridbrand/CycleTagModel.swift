//
//  CycleModel.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

public class CycleTagModel: BaseModel {
    
    public var cycle_id: Int64 = 0
    public var tag_id: Int64 = 0
    
    
    public override init() {
        super.init()
    }
    
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.cycle_id = DataConverter.toInt64(data["cycle_id"])
        self.tag_id = DataConverter.toInt64(data["tag_id"])
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["cycle_id"] = cycle_id
        dict["tag_id"] = tag_id
        
        return dict
    }
    
    func cycle() -> CycleModel {
        return CycleDao().findById(cycle_id)!
    }
    
    func tag() -> TagModel {
        return TagDao().findById(tag_id)!
    }
}
