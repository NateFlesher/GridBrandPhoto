//
//  AppDelegate.swift
//  gridbrand
//
//  Created by LionStar on 1/6/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        _ = AppSession.loadCurrentUser()
        
        guard let database = Database() else {
            fatalError("could not setup database")
        }
        
        do {
            try database.migrateIfNeeded()
        } catch {
            fatalError("failed to migrate database: \(error)")
        }
        
        print(database)
        
        //testDatabaseAPIs()

        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "UVFFunkydori", size: 24)!
        ]
        
        
        
        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    func testDatabaseAPIs() {
        /*let userDao = UserDao()
        let users = userDao.find(["filter":"created_time<\(Int(NSDate().timeIntervalSince1970))"])
        print(users)
        let user: UserModel = users[0]
        print(user)
        print(user.email)
        let user1 = userDao.findById(2)
        print(user1)
        
        user1?.note = "I am working in my office room now"
        _ = userDao.update(user1!)
        
        var deletes = userDao.delete(3)
        userDao.delete(5)
        let users1 = userDao.find()
        
        
        let cycleDao = CycleDao()
        for cycle in cycleDao.find(["filter":"created_time<\(Int(NSDate().timeIntervalSince1970))"]) {
            print(cycle.toDictionary())
        }
        
        let cycle = cycleDao.findById(3)
        print(cycle?.toDictionary())
        cycle?.data = Blob(bytes: [45,12,54,8,76,5,44,32,123])
        cycleDao.update(cycle!)
        
        let cycle1 = cycleDao.findById(3)
        
        deletes = cycleDao.delete(4)
        
        
        let messageDao = MessageDao()
        for message in messageDao.find(["filter":"created_time<\(Int(NSDate().timeIntervalSince1970))"]) {
            print(message.toDictionary())
        }
        
        let message = messageDao.findById(3)
        print(message?.toDictionary())
        message?.message = "That is test message"
        messageDao.update(message!)
        
        let message1 = messageDao.findById(3)
        
        deletes = messageDao.delete(4)*/
    }
}

