//
//  CycleService.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class MessageService {
    
    static let sharedInstance = MessageService()
    
    static let PageSize = 50
    
    let dao = MessageDao()
    
    func loadData(user_id: Int64?, page: Int = 1) -> [MessageModel] {        
        
        if user_id != nil {
            return dao.find([
                "filter": "to_user_id=\(user_id!)",
                "sort": "created_time DESC",
                "offset": (page - 1) * MessageService.PageSize,
                "limit": MessageService.PageSize
                ])
        } else {
            return []
        }
    }
    
}
