//
//  GbLoginView.swift
//  postcraft
//
//  Created by LionStar on 1/20/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
#endif

class GbLoginView: GbCustomView {
    
    var closedHandler: (() -> Void)? = nil
    var loggedInHandler: ((_ user:UserModel) -> Void)? = nil
    
    @IBOutlet weak var inputValidLabel: UILabel!
    @IBOutlet weak var emailTextField: GbRoundedTextField!
    @IBOutlet weak var passwordTextField: GbRoundedTextField!
    @IBOutlet weak var loginBtn: GbRoundedButton!

    @IBAction func closeBtnTapped(_ sender: AnyObject) {
        self.closedHandler?()
    }
    
    @IBAction func loginBtnTapped(_ sender: AnyObject) {
        let disposeBag = DisposeBag()
        
        let loggingIn = ActivityIndicator()
        
        let email = emailTextField.text
        if (email?.isEmpty)! {
            inputValidLabel.isHidden = false
            inputValidLabel.text = "Email required"
            return
        }
        let password = self.passwordTextField.text
        if (password?.isEmpty)! {
            inputValidLabel.isHidden = false
            inputValidLabel.text = "Password required"
            return
        }
        inputValidLabel.isHidden = true
        
        self.endEditing(true)
        
        GridbrandDefaultAPI.sharedAPI.login(email: email!, password: password!)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(UserModel())
            .trackActivity(loggingIn)
            .shareReplay(1)
            .subscribe(onNext: { user in
                print("Logged in \(user)")
                self.loggedInHandler?(user)
            })
            .addDisposableTo(disposeBag)
        
        
        loggingIn.asObservable()
            .subscribe(onNext:{processing in
                print(processing)
                self.loginBtn.isEnabled = !processing
                self.loginBtn.loadingIndicator(show: processing)
                
            })
            .addDisposableTo(disposeBag)
    }
    
    @IBAction func forgetPasswordBtnTapped(_ sender: AnyObject) {
        self.endEditing(true)
        
        let view = GbForgetPasswordView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:227))
        let layout = KLCPopupLayoutMake(.center, .top)
        
        let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceInFromTop, dismissType: .bounceOutToTop, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        view.parentPopup = popup
        view.sentHandler = { email in
            self.showResetPasswordEmailSentConfirmPopup(email: email)
        }
        
        popup.show(with: layout)
        
    }
    
    
    func showResetPasswordEmailSentConfirmPopup(email: String) {
        let frame = self.view.frame
        let view = GbResetPasswordEmailSentView(frame: CGRect(x:0, y:0, width:frame.size.width-40, height:400))
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        
        let layout = KLCPopupLayoutMake(.center, .center)
        
        let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        view.parentPopup = popup        
        view.emailLabel.text = email
        view.email = email
        
        popup.show(with: layout)
    }
}
