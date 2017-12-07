//
//  GbNotificationVC.swift
//  postcraft
//
//  Created by LionStar on 1/25/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class GbNotificationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let data: Variable<[NotificationModel]> = Variable([])
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.register(UINib(nibName: "GbNotificationTVCell", bundle: nil), forCellReuseIdentifier: GbNotificationTVCell.Identifier)
        
        tableView.backgroundView = GbEmptyView.create()
        tableView.backgroundView?.isHidden = true
        
        data.asObservable()
            .do(onNext: { notifications in
                self.tableView.backgroundView?.isHidden = notifications.count>0
            })
            .bindTo(tableView
                .rx
                .items(cellIdentifier: GbNotificationTVCell.Identifier,
                       cellType: GbNotificationTVCell.self)) {
                        row, notification, cell in
                        
                        cell.bindModel(model: notification)
                        
                        cell.avatarButtonTapHandler = { (c:GbNotificationTVCell, sender:AnyObject) in
                            let vc:GbProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! GbProfileVC
                            vc.user = notification.fromUser()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                        cell.thumbnailButtonTapHandler = { (c:GbNotificationTVCell, sender:AnyObject) in
                            print("Should move to selected cycle post view controller")
                        }
                        
            }
            .addDisposableTo(disposeBag)
        
        let currentUser = AppSession.currentUser
        data.value = NotificationService.sharedInstance.loadData(user_id: currentUser?.id)
    }

    @IBAction func backBtnTapped(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
