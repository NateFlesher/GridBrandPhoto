//
//  CycleDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class CycleDao: BaseDao {
    
    let table = Table("tbl_cycles")
    
    let user_id =  Expression<Int64>("user_id")
    let title = Expression<String>("title")
    let photo_url = Expression<String>("photo_url")
    let note = Expression<String>("note")
    let data = Expression<Blob>("data")
    let magic = Expression<Bool>("magic")
    let counting = Expression<Bool>("counting")
    let price_unit = Expression<String>("price_unit")
    let price = Expression<Double>("price")
    
    init() {
        super.init("tbl_cycles")
    }
    
    func findById(_ modelId:Int64)->CycleModel? {
        if let item = super._findById(modelId) {
            return CycleModel(data:item)
        }
        return nil        
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [CycleModel] {
        let result = super._find(params)
        
        var models: [CycleModel] = []
        for item in result {
            models.append(CycleModel(data:item))
        }
        
        return models
    }
}
