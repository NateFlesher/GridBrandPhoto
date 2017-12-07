//
//  GbSignupEmailSentView.swift
//  postcraft
//
//  Created by LionStar on 1/20/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit
import Toast_Swift

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


class GbSignupEmailSentView: GbCustomView {
    var parentPopup: KLCPopup? = nil
    
    var confirmedHandler: ((_ user:UserModel) -> Void)? = nil
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sendAgainBtn: GbRoundedButton!
    @IBOutlet weak var confirmBtn: GbRoundedButton!
    
    @IBAction func closeBtnTapped(_ sender: AnyObject) {
        parentPopup?.dismiss(true)
    }
    @IBAction func sendAgainBtnTapped(_ sender: AnyObject) {
        let senting = ActivityIndicator()
        GridbrandDefaultAPI.sharedAPI.requestEmailVerify(accessToken: AppSession.accessToken ?? "f1c9b748-c37a-4348-9b15-1f5f9c6297ce")
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(false)
            .trackActivity(senting)
            .subscribe(onNext:{ (sent:Bool) in
                print("Sent email verification \(sent)")
            })
            .addDisposableTo(disposeBag)
        
        
        senting.asObservable()
            .subscribe(onNext:{processing in
                print(processing)
                self.sendAgainBtn.isEnabled = !processing
                self.confirmBtn.isEnabled = !processing
                
                self.sendAgainBtn.loadingIndicator(show: processing)
                
            })
            .addDisposableTo(disposeBag)
        
    }
    
    @IBAction func confirmBtnTapped(_ sender: AnyObject) {
        let checking = ActivityIndicator()
        GridbrandDefaultAPI.sharedAPI.getCurrentUser(accessToken: "f1c9b748-c37a-4348-9b15-1f5f9c6297ce")
            .observeOn(MainScheduler.instance)
            .trackActivity(checking)
            .subscribe(
                onNext:{(user:UserModel) in
                    print("Sent email verification \(user)")
                    user.email_verified = true
                    if user.email_verified {
                        self.parentPopup?.dismiss(true)
                        self.parentPopup?.didFinishDismissingCompletion = {                            
                            self.confirmedHandler?(user)
                        }
                    }
                },
                onError: { err in
                    print(err)
                    self.view.makeToast(err.localizedDescription)
                }
            )
            .addDisposableTo(disposeBag)
        
        
        checking.asObservable()
            .subscribe(onNext:{processing in
                print(processing)
                self.sendAgainBtn.isEnabled = !processing
                self.confirmBtn.isEnabled = !processing
                
                self.confirmBtn.loadingIndicator(show: processing)
                
            })
            .addDisposableTo(disposeBag)       
        
    }
}
