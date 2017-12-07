//
//  CycleService.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class TagService {
    let data: Variable<[TagModel]> = Variable([])
    
    static let sharedInstance = TagService()
    
    static let PageSize = 50
    
    
    func loadData() {
        let dao = TagDao()
        
        data.value = dao.find()
    }
    
    func getTags() -> [TagModel] {
        return TagDao().find()
    }
}
