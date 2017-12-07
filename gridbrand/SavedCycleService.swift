//
//  CycleService.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class SavedCycleService {
    static let sharedInstance = SavedCycleService()    
    static let PageSize = 50
    
    let dao = SavedCycleDao()
    
    func loadData(user_id: Int64?, page: Int = 1) -> [SavedCycleModel] {
        let dao = SavedCycleDao()
        
        if user_id != nil {
            return dao.find([
                "filter": "user_id=\(user_id!)",
                "sort": "created_time DESC",
                "offset": (page - 1) * SavedCycleService.PageSize,
                "limit": SavedCycleService.PageSize
                ])
        } else {
            return []
        }
    }
}
