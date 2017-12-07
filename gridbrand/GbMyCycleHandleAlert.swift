//
//  GbMyCycleHandleAC.swift
//  postcraft
//
//  Created by LionStar on 1/16/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbMyCycleHandleActionResult {
    case sendToFriend
    case fastShare
    case makeCopy
    case delete
    case cancel
}

class GbMyCycleHandleAlert {
    
    let controller: UIAlertController

    init(completion: @escaping (_ result: GbMyCycleHandleActionResult) -> Void) {
        controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let sendToFriendAction = UIAlertAction(title: "Send To Friend", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.sendToFriend)
        })
        controller.addAction(sendToFriendAction)
        
        let fastShareAction = UIAlertAction(title: "Fast Share", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.fastShare)
        })
        controller.addAction(fastShareAction)
        
        let makeCopyAction = UIAlertAction(title: "Make Copy", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.makeCopy)
        })
        controller.addAction(makeCopyAction)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.delete)
        })
        controller.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.cancel)
        })
        controller.addAction(cancelAction)
    }

}
