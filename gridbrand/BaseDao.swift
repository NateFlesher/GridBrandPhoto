//
//  UserDao.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

class BaseDao {
    
    let tableName: String
    let db: Connection
    
    let id = Expression<Int64>("id")    
    let created_time = Expression<Int64>("created_time")
    let updated_time = Expression<Int64>("updated_time")

    init (_ tableName:String) {
        self.db = Database.sharedInstance!
        self.tableName = tableName
    }
    
    init (_ tableName:String, db: Connection) {
        self.db = db
        self.tableName = tableName
    }
    
    func create(_ model:BaseModel)->Int64? {
        do {
            let data = model.toDictionary()
            
            let id = data["id"] as! Int64? ?? 0
            if(id > 0) {
                
                let fields = ([String] (data.keys)).joined(separator: ",")
                let questions = (1...data.values.count).map{_ in "?"}.joined(separator: ",")
                let values = ([Any] (data.values)).map { (val:Any) -> (Binding) in
                    if let v = val as? Double {
                        return v as Double
                    } else if let v = val as? Int64 {
                        return v as Int64
                    } else if let v = val as? Bool {
                        return v as Bool
                    } else if let v = val as? Blob {
                        return v as Blob
                    } else {
                        return val as! String
                    }
                }
                
                let stmt = try db.prepare("INSERT INTO \(tableName) (\(fields)) VALUES (\(questions))")
                try stmt.run(values)
                
                return db.lastInsertRowid
            }
            return 0
            
        } catch {
            print("\(String(describing: type(of: self))) ===== insertion failed: \(error)")
            return nil
        }
    }
    
    func update(_ model:BaseModel)->Int? {
        do {
            let data = model.toDictionary()
            
            let id = data["id"] as! Int64? ?? 0
            if(id > 0) {
                
                let fields = ([String] (data.keys)).map{"\($0)=?"}.joined(separator: ",")
                let values = ([Any] (data.values)).map{"\($0)"}
                
                let stmt = try db.prepare("UPDATE \(tableName) SET \(fields) WHERE id=\(id)")
                try stmt.run(values)
                
                return db.changes
            }
            return 0
            
        } catch {
            print("\(String(describing: type(of: self))) ===== update failed: \(error)")
            return nil
        }
    }
    
    func delete(_ modelId:Int64)->Int? {
        do {
            if(modelId > 0) {
                
                let stmt = try db.prepare("DELETE FROM \(tableName) WHERE id=\(modelId)")
                try stmt.run()
                
                return db.changes
            }
            return 0
            
        } catch {
            print("\(String(describing: type(of: self))) ===== update failed: \(error)")
            return nil
        }
    }
    
    func _find(_ params:Dictionary<String, Any>?=nil)->[Dictionary<String, Any>] {
        do {
            var query = "SELECT * FROM \(tableName) WHERE 1=1"
            
            
            if let filter = params?["filter"] {
                query += " AND \(filter)"
            }
            
            if let sort = params?["sort"] {
                query += " ORDER BY \(sort)"
            }
            
            if let limit = params?["limit"] {
                query += " LIMIT \(params?["offset"] ?? 0), \(limit)"
            }
            
            
            let stmt = try db.prepare(query)
            
            var result:[Dictionary<String, Any>] = []
            for row in stmt {
                var data: Dictionary<String, Any> = Dictionary()
                for (index, name) in stmt.columnNames.enumerated() {
                    if row[index] != nil {
                        data[name] = row[index]!
                    }
                }
                result.append(data)
                
            }
            return result
        } catch {
            print("\(String(describing: type(of: self))) ===== find failed: \(error)")
            return []
        }
    }
    
    func _findById(_ modelId:Int64)->Dictionary<String, Any>? {
        do {
            var result: Dictionary<String, Any>? = nil
            let stmt = try db.prepare("SELECT * FROM \(tableName) WHERE id=\(modelId)")
            
            for row in stmt {
                var data: Dictionary<String, Any> = Dictionary()
                for (index, name) in stmt.columnNames.enumerated() {
                    if row[index] != nil {
                        data[name] = row[index]!
                    }
                }
                result = data
                
            }
            return result
        } catch {
            print("\(String(describing: type(of: self))) ===== update failed: \(error)")
            return nil
        }
    }
}
