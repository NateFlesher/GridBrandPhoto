//
//  CycleDao.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class CategoryDao: BaseDao {
    
    let table = Table("tbl_categories")
    
    let title = Expression<String>("title")
    let icon_url = Expression<String>("icon_url")
    let note = Expression<String>("note")
    
    init() {
        super.init("tbl_categories")
    }
    
    func findById(_ modelId:Int64) -> CategoryModel? {
        if let item = super._findById(modelId) {
            return CategoryModel(data:item)
        }
        return nil
    }
    
    func find(_ params: Dictionary<String, Any>?=nil) -> [CategoryModel] {
        let result = super._find(params)
        
        var models: [CategoryModel] = []
        for item in result {
            models.append(CategoryModel(data:item))
        }
        
        return models
    }
}
