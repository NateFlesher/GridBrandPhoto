//
//  CycleService.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class CycleService {
    
    static let sharedInstance = CycleService()
    
    static let PageSize = 50
    
    let dao = CycleDao()
    
    
    func loadData(user_id: Int64?, page: Int = 1) -> [CycleModel] {
        if user_id != nil {
            return  dao.find([
                "filter": "user_id=\(user_id!)",
                "sort": "created_time DESC",
                "offset": (page - 1) * CycleService.PageSize,
                "limit": CycleService.PageSize
                ])
        } else {
            return []
        }
    }
    
    
    func loadData(_ filters: Dictionary<String, Any>?=nil, page: Int = 1) -> [CycleModel] {
        var filter: String = ""
        var params = [
            "sort": "created_time DESC",
            "offset": (page - 1) * CycleService.PageSize,
            "limit": CycleService.PageSize
        ] as [String : Any]
        
        if let magic = filters?["magic"] as? Bool {
            filter += "magic=\(magic ? 1 : 0)"
        }
        if let category_id=filters?["category_id"] as? Int64 {
            filter += " AND category_id=\(category_id)"
        }
        
        params["filter"] = filter
        
        var cycles: [CycleModel] = dao.find(params)
        
        if let tag_ids=filters?["tag_ids"] as? [Int64] {
            if tag_ids.count > 0 {
                let joinedTagIds = tag_ids.map{"\($0)"}.joined(separator: ",")
                let cycleTags = CycleTagDao().find(["filter": "tag_id IN (\(joinedTagIds))"])
                
                cycles = cycles.filter({ (cycle) -> Bool in
                    return cycleTags.map{$0.cycle_id}.contains(where: { $0 == cycle.id })
                })
            }
            
        }
        return cycles
    }
}
