//
//  GbLoginPromptView.swift
//  postcraft
//
//  Created by LionStar on 1/20/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


protocol GbLoginPromptViewDelegate {
    func loggedIn(view:GbLoginPromptView, user:UserModel)
    func signedUp(view:GbLoginPromptView, user:UserModel)
}

class GbLoginPromptView: GbCustomView {
    let disposeBag = DisposeBag()
    
    var parentPopup: KLCPopup? = nil
    var delegate: GbLoginPromptViewDelegate? = nil
    
    @IBAction func closeBtnTapped(_ sender: AnyObject) {
        parentPopup?.dismiss(true)
        
    }
    @IBAction func loginBtnTapped(_ sender: AnyObject) {
        let loginView = GbLoginView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:247))
        self.addSubview(loginView)
        
        loginView.force = 2
        loginView.duration = 0.8
        loginView.animation = "slideRight"
        loginView.animate()
        
        loginView.closedHandler = {
            self.parentPopup?.dismiss(true)
        }        
        loginView.loggedInHandler = { user in
            self.parentPopup?.dismiss(true)
            self.parentPopup?.didFinishDismissingCompletion = {
                self.delegate?.loggedIn(view: self, user: user)
            }
        }
        
    }
    @IBAction func signupBtnTapped(_ sender: AnyObject) {
        let signupView = GbSignupView(frame: CGRect(x:0, y:0, width:self.frame.size.width, height:454))
        self.addSubview(signupView)
        
        signupView.force = 2
        signupView.duration = 0.8
        signupView.animation = "slideLeft"
        signupView.animate()
        
        signupView.closedHandler = {
            self.parentPopup?.dismiss(true)
        }
        signupView.signedUpHandler = { user in
            self.parentPopup?.dismiss(true)
            self.parentPopup?.didFinishDismissingCompletion = {
                self.delegate?.signedUp(view: self, user: user)                
            }
        }
    }
}
