//
//  NotificationService.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class NotificationService {
    
    static let sharedInstance = NotificationService()
    
    static let PageSize = 50
    
    let dao = NotificationDao()
    
    func loadData(user_id: Int64?, page: Int = 1) -> [NotificationModel] {
        
        if user_id != nil {
            return dao.find([
                "filter": "to_user_id=\(user_id!)",
                "sort": "created_time DESC",
                "offset": (page - 1) * NotificationService.PageSize,
                "limit": NotificationService.PageSize
                ])
        } else {
            return []
        }
    }
    
}
