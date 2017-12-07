//
//  GbMyCycleHandleAC.swift
//  postcraft
//
//  Created by LionStar on 1/16/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbOthersCycleHandleActionResult {
    case save
    case sendMessage
    case report
    case cancel
}

class GbOthersCycleHandleAlert {
    
    let controller: UIAlertController

    init(completion: @escaping (_ result: GbOthersCycleHandleActionResult) -> Void) {
        controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.save)
        })
        controller.addAction(saveAction)
        
        let sendMessageAction = UIAlertAction(title: "Send Message", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.sendMessage)
        })
        controller.addAction(sendMessageAction)
        
        let reportAction = UIAlertAction(title: "Report", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.report)
        })
        controller.addAction(reportAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            completion(.cancel)
        })
        controller.addAction(cancelAction)
    }

}
