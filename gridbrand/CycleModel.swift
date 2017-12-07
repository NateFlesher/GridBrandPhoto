//
//  CycleModel.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

enum CyclePriceUnit: String {
    case none = ""
    case dollar = "$"
    case cycle = "cycle"
}
public class CycleModel: BaseModel {
    
    var user_id: Int64 = 0
    var title: String = ""
    var photo_url: String = ""
    var note: String = ""
    var data: Blob = Blob(bytes: [])
    var magic: Bool = false
    var counting: Bool = false
    var price_unit: String = CyclePriceUnit.none.rawValue
    var price: Double = 0
    var category_id: Int64 = 0
    
    
    public override init() {
        super.init()
    }
    
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.user_id = DataConverter.toInt64(data["user_id"])
        self.title = data["title"] as! String? ?? ""
        self.photo_url = data["photo_url"] as! String? ?? ""
        self.note = data["note"] as! String? ?? ""
        
        self.data = DataConverter.toBlob(data["data"])
        
        self.magic = DataConverter.toBool(data["magic"])
        self.counting = DataConverter.toBool(data["counting"])
        
        self.price_unit = data["price_unit"] as! String? ?? ""
        self.price = data["price"] as! Double? ?? 0.0
        self.category_id = DataConverter.toInt64(data["category_id"])
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["user_id"] = user_id
        dict["title"] = title
        dict["photo_url"] = photo_url
        dict["note"] = note
        dict["data"] = data
        dict["magic"] = magic
        dict["counting"] = counting
        dict["price_unit"] = price_unit
        dict["price"] = price
        dict["category_id"] = category_id
        dict["note"] = note
        
        return dict
    }
    
    func user()->UserModel {
        let userDao = UserDao()
        return userDao.findById(user_id)!
    }
    
    func category() -> CategoryModel? {
        if category_id == 0 {return nil}
        
        return CategoryDao().findById(category_id)
    }
    
    func tags() -> [TagModel] {
        
        let cycleTags = CycleTagDao().find(["filter": "cycle_id=\(id)"])
        
        return cycleTags.map { $0.tag()}
    }
}
