//
//  GbPhotoEditVC.swift
//  postcraft
//
//  Created by LionStar on 2/6/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

enum GbPhotoEditMainMenu {
    case logo
    case element
    case font
    case search
}

class GbPhotoEditVC: UIViewController {
    @IBOutlet weak var topToolbar: UIView!
    @IBOutlet weak var undoRedoView: UIView!
    @IBOutlet weak var layerUpDownView: UIView!
    @IBOutlet weak var mainMenuLogoBtn: UIButton!
    @IBOutlet weak var mainMenuElementBtn: UIButton!
    @IBOutlet weak var mainMenuFontBtn: UIButton!
    @IBOutlet weak var mainMenuSearchBtn: UIButton!
    
    @IBOutlet weak var middleToolbar: GbEditToolbar!
    @IBOutlet weak var subMenuParentView: UIView!
    @IBOutlet weak var logoMenuView: GbLogoMenuView!
    @IBOutlet weak var elementMenuView: GbElementMenuView!
    @IBOutlet weak var fontMenuView: GbFontMenuView!
    
    var mainMenu: GbPhotoEditMainMenu = .element
    var backgroundColor: UIColor = GbColor.green

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        undoRedoView.layer.borderWidth = 1
        undoRedoView.layer.borderColor = UIColor.white.cgColor
        undoRedoView.layer.cornerRadius = 12.5
        undoRedoView.clipsToBounds = true
        
        layerUpDownView.layer.borderWidth = 1
        layerUpDownView.layer.borderColor = UIColor.white.cgColor
        layerUpDownView.layer.cornerRadius = 12.5
        layerUpDownView.clipsToBounds = true
        
        elementMenuView.delegate = self
        logoMenuView.delegate = self
        fontMenuView.delegate = self
        
        selectMainMenu(menu: .element)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated:true)
    }

    func selectMainMenu(menu:GbPhotoEditMainMenu) {
        mainMenu = menu
        
        mainMenuLogoBtn.setImage(UIImage(named:"logo_black"), for: .normal)
        mainMenuElementBtn.setImage(UIImage(named:"element_black"), for: .normal)
        mainMenuFontBtn.setImage(UIImage(named:"font_black"), for: .normal)
        mainMenuSearchBtn.setImage(UIImage(named:"search_black"), for: .normal)
        
        switch mainMenu {
        case .logo:
            backgroundColor = GbColor.purple
            mainMenuLogoBtn.setImage(UIImage(named:"logo_purple"), for: .normal)
        case .element:
            backgroundColor = GbColor.green
            mainMenuElementBtn.setImage(UIImage(named:"element_green"), for: .normal)
        case .font:
            backgroundColor = GbColor.blue
            mainMenuFontBtn.setImage(UIImage(named:"font_blue"), for: .normal)
        case .search:
            backgroundColor = GbColor.green
            mainMenuSearchBtn.setImage(UIImage(named:"search_green"), for: .normal)
        }
        
        topToolbar.backgroundColor = backgroundColor
        middleToolbar.setEditMainMenu(menu: menu)
        
        setSubMenuByMainMenu(menu:menu)
    }
    
    func setSubMenuByMainMenu(menu:GbPhotoEditMainMenu) {
        logoMenuView.isHidden = menu != .logo
        elementMenuView.isHidden = menu != .element
        fontMenuView.isHidden = menu != .font
        //searchSubMenuView.isHidden = menu != .logo
        
//        switch mainMenu {
//        case .logo:
//            backgroundColor = GbColor.purple
//            mainMenuLogoBtn.setImage(UIImage(named:"logo_purple"), for: .normal)
//        case .element:
//            backgroundColor = GbColor.green
//            mainMenuElementBtn.setImage(UIImage(named:"element_green"), for: .normal)
//        case .font:
//            backgroundColor = GbColor.blue
//            mainMenuFontBtn.setImage(UIImage(named:"font_blue"), for: .normal)
//        case .search:
//            backgroundColor = GbColor.green
//            mainMenuSearchBtn.setImage(UIImage(named:"search_green"), for: .normal)
//        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK - @IBAction methods
    @IBAction func mainMenuLogoBtnTapped(_ sender: Any) {
        selectMainMenu(menu:.logo)
    }
    @IBAction func mainMenuElementBtnTapped(_ sender: Any) {
        selectMainMenu(menu:.element)
    }
    @IBAction func mainMenuFontBtnTapped(_ sender: Any) {
        selectMainMenu(menu:.font)
    }
    @IBAction func mainMenuSearchBtnTapped(_ sender: Any) {
        selectMainMenu(menu:.search)
    }
    
}


extension GbPhotoEditVC:GbElementMenuViewDelegate {
    func didSelectedMenu(menu: GbElementMenu, sender: Any) {
        switch menu {
        case .color:
            showColorEditDialog()
        default: break
            
        }
    }
    
    func showColorEditDialog() {
        let frame = self.view.frame
        let v = GbElementColorEditView(frame: CGRect(x:0, y:0, width:frame.size.width, height:249))
        
        let layout = KLCPopupLayoutMake(.center, .bottom)
        
        let popup:KLCPopup = KLCPopup(contentView: v, showType: .bounceInFromBottom, dismissType: .bounceOutToBottom, maskType: .none, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        v.parentPopup = popup
        
        v.acceptHandler = { (obj:Any?) in
            //completion(result)
        }
        popup.show(with: layout)

    }
}

extension GbPhotoEditVC:GbLogoMenuViewDelegate {
    func didSelectedMenu(menu: GbLogoMenu, sender: Any) {
        
    }
}

extension GbPhotoEditVC:GbFontMenuViewDelegate {
    func didSelectedMenu(menu: GbFontMenu, sender: Any) {
        
    }
}
