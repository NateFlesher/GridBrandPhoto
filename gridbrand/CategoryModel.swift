//
//  CycleModel.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

public class CategoryModel: BaseModel {
    
    public var title: String = ""
    public var icon_url: String = ""
    public var note: String = ""
    
    
    public override init() {
        super.init()
    }
    
    
    public override init(data:Dictionary<String, Any>) {
        super.init(data:data)
        
        self.title = data["title"] as! String? ?? ""
        self.icon_url = data["icon_url"] as! String? ?? ""
        self.note = data["note"] as! String? ?? ""
    }
    
    public override func toDictionary()->Dictionary<String, Any> {
        var dict = super.toDictionary()
        
        dict["title"] = title
        dict["icon_url"] = icon_url
        dict["note"] = note
        
        return dict
    }
    
}
