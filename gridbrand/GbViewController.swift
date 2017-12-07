//
//  GbViewController.swift
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

class GbViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var loginPromptCallback:((UserModel) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTapBackgroundObserver(editView: UIView, tapView: UIView) {
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { _ in
                editView.endEditing(true)
                })
            .addDisposableTo(disposeBag)
        tapView.addGestureRecognizer(tapBackground)
    }
    
    func showLoginPromptPopup(callback: @escaping (UserModel) -> Void) {
        
        let view = GbLoginPromptView(frame: self.view.frame)
        let layout = KLCPopupLayoutMake(.center, .top)
        
        let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceInFromTop, dismissType: .bounceOutToTop, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        view.parentPopup = popup
        view.delegate = self
        
        setupTapBackgroundObserver(editView:view, tapView:view)
        popup.show(with: layout)
        
        self.loginPromptCallback = callback
    }
    
    
    
}



extension GbViewController: GbLoginPromptViewDelegate {
    func signedUp(view: GbLoginPromptView, user: UserModel) {
        print("===Signed in user \(user)")
        
        showSignupEmailSentConfirmPopup(parentView:self.view, email: user.email) { (user) in
            // Should be removed
            AppSession.currentUser?.email = user.email
            AppSession.currentUser?.email_verified = user.email_verified
            
            self.loginPromptCallback?(AppSession.currentUser!)
        }
    }
    
    func loggedIn(view: GbLoginPromptView, user: UserModel) {
        print("===Logged in user \(user)")
        self.loginPromptCallback?(user)
    }
}



fileprivate let sectionInsets = UIEdgeInsets(top: 13.0, left: 13.0, bottom: 13.0, right: 13.0)
fileprivate let itemsPerRow: CGFloat = 2
extension GbViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout:UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
