//
//  GbCycleVC.swift
//  gridbrand
//
//  Created by LionStar on 1/8/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit
import Popover

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class GbCycleVC: GbViewController {
    static let filterMenuTVCellIdentifier = "filterMenuTVCellIdentifier"
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var categoryView: GbCategoryView!
    @IBOutlet weak var tagInputView: CLTokenInputView!
    @IBOutlet weak var tagInputHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var cycleCollectionView: UICollectionView!
    
    var selectedCategory: CategoryModel? = nil
    
    var tags: [TagModel] = []
    var selectedTags: Variable<[TagModel]> = Variable([])
    var filteredTags: Variable<[TagModel]> = Variable([])
    
    var cycleData: Variable<[CycleModel]> = Variable([])
    
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        setupTagInputView()
        setupCycleView()
        loadData()
        
        self.perform(#selector(setupCategoryView), with: nil, afterDelay: 0.1)
        
        setupTapBackgroundObserver(editView:self.view, tapView:self.cycleCollectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        
    }
    
    func setupUI() {
        
    }
    
    func setupTagInputView() {
        
        self.tagInputView.fieldView = UIImageView(image:#imageLiteral(resourceName: "search"));
        self.tagInputView.placeholderText = "Enter a tag name";
        //self.tagInputView.accessoryView = self.contactAddButton();
        self.tagInputView.drawBottomBorder = true;
        self.tagInputView.delegate = self
        
        self.filteredTags.asObservable()
            .do(onNext: { tags in
                //self.cycleCollectionView.backgroundView?.isHidden = cycles.count>0
            })
            .bindTo(tagTableView.rx.items) { (tableView, row, tag) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 13.0)
                cell.textLabel?.text = tag.title
                
                if self.selectedTags.value.contains(where: {$0.id == tag.id}) {
                    cell.accessoryType = .checkmark
                }
                else {
                    cell.accessoryType = .none
                }
                
                return cell
                
            }
            .addDisposableTo(disposeBag)
        
        self.tagTableView
            .rx
            .modelSelected(TagModel.self)
            .subscribe(onNext: { tag in
                
                if let indexPath = self.tagTableView.indexPathForSelectedRow {
                    self.tagTableView.deselectRow(at: indexPath, animated: true)
                    
                    let token:CLToken = CLToken()
                    token.displayText = "#\(tag.title)"
                    token.context = tag
                    
                    if self.tagInputView.isEditing() {
                        self.tagInputView.addToken(token)
                    }
                    
                }
            })
            .addDisposableTo(disposeBag)
        
        self.selectedTags.asObservable()
            .subscribe(onNext: { tags in
                self.loadData()
            })
            .addDisposableTo(disposeBag)
        
        self.tagTableView.isHidden = true
        
        self.tags = TagService.sharedInstance.getTags()
    }
    
    func setupCategoryView() {
        categoryView.delegate = self
        CategoryService.sharedInstance.data.asObservable()
            .do(onNext: { categories in
                //self.cycleCollectionView.backgroundView?.isHidden = cycles.count>0
            })
            .bindTo(categoryView.rx.data)
            .addDisposableTo(disposeBag)
        CategoryService.sharedInstance.loadData()
    }
    
    func setupCycleView() {
        cycleCollectionView.register(UINib(nibName: "GbCycleCVCell", bundle: nil), forCellWithReuseIdentifier: "CycleCVCell")
        
        let emptyView = GbEmptyView.create()
        emptyView.messageLabel.text = "We can't find cycles"
        cycleCollectionView.backgroundView = emptyView
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
                            if AppSession.currentUser != nil {
                                if cycle.user_id == AppSession.currentUser?.id {
                                    self.present(GbMyCycleHandleAlert(completion:{ result in
                                        print(result)
                                    }).controller, animated: true, completion: nil)
                                } else {
                                    self.present(GbOthersCycleHandleAlert(completion:{ result in
                                        print(result)
                                        
                                        switch result {
                                        case .report:
                                            showReportDialog(for: cycle, on: self.view)
                                        default: break
                                        }
                                    }).controller, animated: true, completion: nil)
                                }
                            }
                        }
                        
                        cell.avatarButtonTapHandler = { (c:GbCycleCVCell, sender:AnyObject) in
                            let currentUser = AppSession.currentUser
                            
                            if currentUser == nil {
                                self.showLoginPromptPopup(callback: { (user) in
                                    let vc:GbProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! GbProfileVC
                                    vc.user = cycle.user()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                })
                            } else {
                                let vc:GbProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! GbProfileVC
                                vc.user = cycle.user()
                                vc.tab = GbProfileTab.profile
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                        cell.photoImageTapHandler = { (c:GbCycleCVCell) in
                            let view = GbCraftCycleView(frame: self.view.frame, cycle:cycle)
                            
                            let layout = KLCPopupLayoutMake(.center, .center)
                            
                            let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
                            
                            popup.show(with: layout)
                            
                            view.closeBtnTapHandler = {(sender:Any) in
                                popup.dismiss(true)
                            }
                            view.craftBtnTapHandler = {(sender:Any) in
                                popup.dismiss(true)
                                popup.didFinishDismissingCompletion = {
                                    let view = GbLoadingCycleView(frame: self.view.frame)
                                    
                                    let layout = KLCPopupLayoutMake(.center, .center)
                                    
                                    let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
                                    
                                    popup.show(with: layout)
                                    
                                    view.loadData(cycle: cycle, callback: { success in
                                        popup.dismiss(true)
                                        
                                        let nc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoEditNC") as! UINavigationController
                                        self.present(nc, animated: true, completion: nil)
                                    })
                                }
                            }
                        }
                        
            }
            .addDisposableTo(disposeBag)
        
        loadData()
    }
    
    
    func loadData() {
        cycleData.value = CycleService.sharedInstance.loadData([
            "magic":false,
            "category_id":self.selectedCategory?.id as Any,
            "tag_ids":self.selectedTags.value.map{$0.id}
            ],
        page:self.page)
    }
    
    // MARK: - @IBAction
    @IBAction func profileBtnTapped(_ sender: AnyObject) {
        let currentUser = AppSession.currentUser
        
        if currentUser == nil {
            showLoginPromptPopup(callback: { (user) in
                let vc:GbProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! GbProfileVC
                vc.user = user
                self.navigationController?.pushViewController(vc, animated: true)
            })
        } else {
            let vc:GbProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! GbProfileVC
            vc.user = currentUser
            vc.tab = GbProfileTab.profile
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    @IBAction func filterBtnTapped(_ sender: AnyObject) {
        
        let options: [PopoverOption] = [
            .type(.down),
            .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
        ]
        let popover:Popover = Popover(options: options)
        
        let menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 120, height: 135))
        menuTableView.isScrollEnabled = false
        
        Observable.just(["Country", "DateRecent", "MostCycle"])
            .bindTo(menuTableView.rx.items) { (tableView, row, menu) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 13.0)
                cell.textLabel?.text = menu
                return cell
            }
            .addDisposableTo(disposeBag)
        
        menuTableView
            .rx
            .modelSelected(String.self)
            .subscribe(onNext: { menu in
                
                if let indexPath = menuTableView.indexPathForSelectedRow {
                    menuTableView.deselectRow(at: indexPath, animated: true)
                    popover.dismiss()
                }
            })
            .addDisposableTo(disposeBag)

        
        popover.show(menuTableView, fromView: self.filterBtn)
    }
    
    @IBAction func createBtnTapped(_ sender: AnyObject) {
        
    }
    @IBAction func magicBtnTapped(_ sender: AnyObject) {
        showWhyMagicPopup(on: self.view) { 
            let nc: UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "MagicShopNC") as! UINavigationController
            self.present(nc, animated: true)
        }        
        
    }
}

extension GbCycleVC: GbCategoryViewDelegate {
    func categorySelected(_ view: GbCategoryView, category: CategoryModel) {
        print("Category selected \(category.toDictionary())")
        self.selectedCategory = category
        self.loadData()
    }
}

extension GbCycleVC: CLTokenInputViewDelegate {
    func tokenInputViewDidEndEditing(_ aView: CLTokenInputView) {
        aView.accessoryView = nil
    }
    func tokenInputViewDidBeginEditing(_ aView: CLTokenInputView) {
        //aView.accessoryView = self.contactAddButton()
        self.view.layoutIfNeeded()
    }
    func tokenInputView(_ aView:CLTokenInputView, didChangeText text:String) {
        if text == "" {
            self.filteredTags.value = []
            self.tagTableView.isHidden = true
        } else {
            self.filteredTags.value = self.tags.filter{ (tag) -> Bool in
                return tag.title.contains(text)
            }
            
            self.tagTableView.isHidden = false
        }
        
    }
    
    func tokenInputView(_ aView:CLTokenInputView, didAddToken token:CLToken) {
        self.selectedTags.value.append(token.context as! TagModel)
    }
    
    func tokenInputView(_ aView:CLTokenInputView, didRemoveToken token:CLToken) {
        let tag = token.context as! TagModel
        let index = self.selectedTags.value.index { (t) -> Bool in
            return tag.id == t.id
        }
        
        self.selectedTags.value.remove(at: index!)
    }
    
    func tokenInputView(_ aView:CLTokenInputView, tokenForText text:String) -> CLToken? {
        if self.filteredTags.value.count > 0 {
            let tag: TagModel = self.filteredTags.value[0]
            let token: CLToken = CLToken()
            token.displayText = "#\(tag.title)"
            token.context = tag
            return token
        }
        return nil
    }
    
    func tokenInputView(_ aView:CLTokenInputView, didChangeHeightTo height:CGFloat) {
        print("TokenInputView height changed to \(height)")
        self.tagInputHeightConstraint.constant = height
    }
}
