//
//  CycleDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class TagDao: BaseDao {
    
    let table = Table("tbl_tags")
    
    let title = Expression<String>("title")
    let note = Expression<String>("note")
     
    init() {
        super.init("tbl_tags")
    }
    
    func findById(_ modelId:Int64) -> TagModel? {
        if let item = super._findById(modelId) {
            return TagModel(data:item)
        }
        return nil
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [TagModel] {
        let result = super._find(params)
        
        var models: [TagModel] = []
        for item in result {
            models.append(TagModel(data:item))
        }
        
        return models
    }
}
