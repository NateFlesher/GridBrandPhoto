//
//  CycleService.swift
//  postcraft
//
//  Created by LionStar on 1/11/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import RxSwift

class CategoryService {
    let data: Variable<[CategoryModel]> = Variable([])
    
    static let sharedInstance = CategoryService()
    
    static let PageSize = 50
    
    let dao = CategoryDao()
    
    func loadData() {
        data.value = dao.find()
    }
}
