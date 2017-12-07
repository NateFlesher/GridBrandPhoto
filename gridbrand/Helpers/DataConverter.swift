//
//  DataConverter.swift
//  postcraft
//
//  Created by LionStar on 1/25/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation
import SQLite

public class DataConverter {
    static func toBool(_ data: Any?) -> Bool {
        if let val = data as? Bool {
            return val
        } else if let val = data as? Int64 {
            return Bool(val != 0)
        } else if let val = data as? NSString {
            return val.boolValue
        } else {
            return false
        }
    }
    
    static func toDouble(_ data: Any?) -> Double {
        if let val = data as? Double {
            return val
        } else if let val = data as? NSNumber {
            return val.doubleValue
        } else if let val = data as? NSString {
            return val.doubleValue
        } else {
            return 0.0
        }
    }
    
    static func toInt64(_ data: Any?) -> Int64 {
        if let val = data as? Int {
            return Int64(val)
        } else if let val = data as? Int64 {
            return val
        } else if let val = data as? NSNumber {
            return val.int64Value
        } else if let val = data as? NSString {
            return Int64(val.integerValue)
        } else {
            return 0
        }
    }
    
    static func toBlob(_ data: Any?) -> Blob {
        if let val = data as? Blob {
            return val
        } else if let val = data as? String {
            return Blob(bytes:[UInt8](val.utf8))
        } else {
            return Blob(bytes:[])
        }
    }
    
    static func toStringDictionary(_ data: Dictionary<String, Any>) -> Dictionary<String, String> {
        var result: Dictionary<String, String> = [String: String]()
        for (key, value) in data {
            result["\(key)"] = "\(value)"
        }
        return result
    }
}
