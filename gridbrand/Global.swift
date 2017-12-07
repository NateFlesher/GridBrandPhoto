//
//  AppSession.swift
//  postcraft
//
//  Created by LionStar on 1/10/17.
//  Copyright © 2017 idan. All rights reserved.
//

import Foundation


struct AppSessionKey {
    static let currentUser = "GB_CURRENT_USER"
    static let accessToken = "GB_ACCESS_TOKEN"
}

class AppSession {
    static var currentUser:UserModel? = nil
    static var accessToken:String? = nil
    
    static public func saveCurrentUser(user:UserModel, accessToken:String?=nil) {
        let defaults = UserDefaults.standard
        
        defaults.set(DataConverter.toStringDictionary(user.toDictionary()), forKey: AppSessionKey.currentUser)
        defaults.set(accessToken, forKey: AppSessionKey.accessToken)
        defaults.synchronize()
        
        AppSession.currentUser = user
        AppSession.accessToken = accessToken
    }
    
    static public func loadCurrentUser()->UserModel? {
        let defaults = UserDefaults.standard
        
        guard let currentUserDict = defaults.object(forKey: AppSessionKey.currentUser) else {
            return nil
        }
        
        AppSession.currentUser = UserModel(data: currentUserDict as! Dictionary)
        
        return AppSession.currentUser
    }
    
    static public func loadAccessToken()->String? {
        let defaults = UserDefaults.standard
        
        guard let accessToken = defaults.object(forKey: AppSessionKey.accessToken) as? String else {
            return nil
        }
        
        AppSession.accessToken = accessToken
        
        return AppSession.accessToken
    }
}
