//
//  GbProfileVC.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class GbProfileVC: GbViewController {
    
    var user: UserModel? = nil
    var tab = GbProfileTab.cycle
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: GbRoundedImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var followBtn: GbRoundedButton!
    @IBOutlet weak var cyclesLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tabBar: GbProfileTabBar!
    @IBOutlet weak var profileView: GbProfileView!
    @IBOutlet weak var cycleCollectionView: UICollectionView!
    @IBOutlet weak var starCollectionView: UICollectionView!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var notificationBtn: UIButton!
    
    @IBOutlet weak var coverLayoutConstraintHeight: NSLayoutConstraint!
    
    let cycleData: Variable<[CycleModel]> = Variable([])
    let savedCycleData: Variable<[SavedCycleModel]> = Variable([])
    let messageData: Variable<[MessageModel]> = Variable([])
    
    var isOuterUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        isOuterUser = user?.id != AppSession.currentUser?.id
        initialize()
        self.perform(#selector(lazyInitialize), with: nil, afterDelay: 0.1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func initialize() {
        setupUI()
        setupObserver()
        loadData()
        
        setupCycleView()
        setupStarView()
        setupMessageView()
    }
    
    func lazyInitialize() {
        self.tabBar.setOuterUser(isOuterUser: isOuterUser)
    }
    
    public func setupUI() {
        self.coverImageView.image = UIImage(named:(user?.cover_url)!)
        self.avatarImageView.image = UIImage(named:(user?.avatar_url)!)
        self.fullnameLabel.text = user?.fullname
        self.professionLabel.text = user?.profession
        
        if (user?.cycle_amount)! >= 100 {   // if user is premium user
            self.avatarImageView.tintColor = GbColor.yellow
            self.fullnameLabel.textColor = GbColor.yellow
            self.professionLabel.textColor = GbColor.yellow
        } else {
            self.avatarImageView.tintColor = UIColor.clear
            self.fullnameLabel.textColor = UIColor.black
            self.professionLabel.textColor = GbColor.lightGray
        }
        
        self.cyclesLabel.text = "\(user?.cycle_amount)"
        self.followersLabel.text = "\(user?.followers.count ?? 0)"
        
        self.profileView.bindData(user!)
        
        self.messageTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.tabBar.activeTab(tab)
        
        coverLayoutConstraintHeight.constant = isOuterUser ? 255 : 220
        followBtn.isHidden = !isOuterUser
        
    }
    public func setupCycleView() {
        cycleCollectionView.register(UINib(nibName: "GbCycleCVCell", bundle: nil), forCellWithReuseIdentifier: GbCycleCVCell.Identifier)
        
        cycleCollectionView.backgroundView = GbEmptyView.create()
        cycleCollectionView.backgroundView?.isHidden = true
        
        cycleData.asObservable()
            .do(onNext: { cycles in
                self.cycleCollectionView.backgroundView?.isHidden = cycles.count>0
            })
            .bindTo(cycleCollectionView
                .rx
                .items(cellIdentifier: GbCycleCVCell.Identifier,
                       cellType: GbCycleCVCell.self)) {
                        row, cycle, cell in
                        cell.bindModel(model: cycle)
                        cell.moreButtonTapHandler = { (c:GbCycleCVCell,sender:AnyObject) in
                            print(cycle.toDictionary())
                            
                            if cycle.user_id == AppSession.currentUser?.id {
                                self.present(GbMyCycleHandleAlert(completion:{ result in
                                    print(result)
                                }).controller, animated: true, completion: nil)
                            } else {
                                self.present(GbOthersCycleHandleAlert(completion:{ result in
                                    print(result)
                                }).controller, animated: true, completion: nil)
                            }
                        }
            }
            .addDisposableTo(disposeBag)
        
        cycleData.value = CycleService.sharedInstance.loadData(user_id: user?.id)
    }
    
    public func setupStarView() {
        starCollectionView.register(UINib(nibName: "GbCycleCVCell", bundle: nil), forCellWithReuseIdentifier: GbCycleCVCell.Identifier)
        
        starCollectionView.backgroundView = GbEmptyView.create()
        starCollectionView.backgroundView?.isHidden = true
        
        savedCycleData.asObservable()
            .do(onNext: { cycles in
                self.starCollectionView.backgroundView?.isHidden = cycles.count>0
            })
            .bindTo(starCollectionView
                .rx
                .items(cellIdentifier: GbCycleCVCell.Identifier,
                       cellType: GbCycleCVCell.self)) {
                        row, cycle, cell in
                        cell.bindModel(model: cycle.cycle())
                        cell.moreButtonTapHandler = { (c:GbCycleCVCell,sender:AnyObject) in
                            print(cycle.toDictionary())
                            
                            if cycle.user_id == AppSession.currentUser?.id {
                                self.present(GbMyCycleHandleAlert(completion:{ result in
                                    print(result)
                                }).controller, animated: true, completion: nil)
                            } else {
                                self.present(GbOthersCycleHandleAlert(completion:{ result in
                                    print(result)
                                }).controller, animated: true, completion: nil)
                            }
                        }
            }
            .addDisposableTo(disposeBag)
        
        savedCycleData.value = SavedCycleService.sharedInstance.loadData(user_id: user?.id)
    }
    
    func setupMessageView() {
        messageTableView.register(UINib(nibName: "GbMessageTVCell", bundle: nil), forCellReuseIdentifier: GbMessageTVCell.Identifier)
        
        messageTableView.backgroundView = GbEmptyView.create()
        messageTableView.backgroundView?.isHidden = true
        
        messageData.asObservable()
            .do(onNext: { messages in
                self.messageTableView.backgroundView?.isHidden = messages.count>0
            })
            .bindTo(messageTableView
                .rx
                .items(cellIdentifier: GbMessageTVCell.Identifier,
                       cellType: GbMessageTVCell.self)) {
                        row, message, cell in
                        cell.bindModel(model: message)                        
                        
                        cell.avatarButtonTapHandler = { (c:GbMessageTVCell, sender:AnyObject) in
                            let vc:GbProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! GbProfileVC
                            vc.user = message.fromUser()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
            }
            .addDisposableTo(disposeBag)
        
        
        messageData.value = MessageService.sharedInstance.loadData(user_id: user?.id)
    }
    public func setupObserver() {
        
        self.tabBar.tab.asObservable()
            .subscribe(onNext:{ tab in
                self.cycleCollectionView.isHidden = tab != GbProfileTab.cycle
                self.starCollectionView.isHidden = tab != GbProfileTab.star
                self.messageTableView.isHidden = tab != GbProfileTab.note
                self.profileView.isHidden = tab != GbProfileTab.profile
            })
            .addDisposableTo(disposeBag)
        
    }
    
    public func loadData() {
    }

    @IBAction func backBtnTapped(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notificationBtnTapped(_ sender: AnyObject) {
        let vc:GbNotificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! GbNotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func followBtnTapped(_ sender: AnyObject) {
        
    }
}
