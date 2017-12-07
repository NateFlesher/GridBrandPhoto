//
//  CycleDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class SavedCycleDao: BaseDao {
    
    let table = Table("tbl_saved_cycles")
    
    let user_id =  Expression<Int64>("user_id")
    let cycle_id =  Expression<Int64>("cycle_id")
    
    init() {
        super.init("tbl_saved_cycles")
    }
    
    func findById(_ modelId:Int64)->SavedCycleModel? {
        if let item = super._findById(modelId) {
            return SavedCycleModel(data:item)
        }
        return nil        
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [SavedCycleModel] {
        let result = super._find(params)
        
        var models: [SavedCycleModel] = []
        for item in result {
            models.append(SavedCycleModel(data:item))
        }
        
        return models
    }
}
