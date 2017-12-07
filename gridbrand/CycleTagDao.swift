//
//  CycleDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class CycleTagDao: BaseDao {
    
    let table = Table("tbl_cycle_tags")
    
    let cycle_id =  Expression<Int64>("cycle_id")
    let tag_id =  Expression<Int64>("tag_id")
    
    init() {
        super.init("tbl_cycle_tags")
    }
    
    func findById(_ modelId:Int64)->CycleTagModel? {
        if let item = super._findById(modelId) {
            return CycleTagModel(data:item)
        }
        return nil        
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [CycleTagModel] {
        let result = super._find(params)
        
        var models: [CycleTagModel] = []
        for item in result {
            models.append(CycleTagModel(data:item))
        }
        
        return models
    }
}
