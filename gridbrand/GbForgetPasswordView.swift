//
//  GbForgetPasswordView.swift
//  postcraft
//
//  Created by LionStar on 1/22/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
#endif

class GbForgetPasswordView: GbCustomView {
    var parentPopup: KLCPopup? = nil
    
    var sentHandler: ((_ email:String)->Void)? = nil
    
    @IBOutlet weak var emailTextField: GbRoundedTextField!
    @IBOutlet weak var inputValidLabel: UILabel!
    @IBOutlet weak var sendBtn: GbRoundedButton!

    

    @IBAction func closeBtnTapped(_ sender: AnyObject) {
        parentPopup?.dismiss(true)
    }
    
    @IBAction func sendBtnTapped(_ sender: AnyObject) {
        let disposeBag = DisposeBag()
        
        let email = self.emailTextField.text
        if (email?.isEmpty)! {
            inputValidLabel.isHidden = false
            inputValidLabel.text = "Email required"
            return
        }
        
        inputValidLabel.isHidden = true
        
        
        let senting = ActivityIndicator()
        
        GridbrandDefaultAPI.sharedAPI.requestResetPassword(email: email!)
            .observeOn(MainScheduler.instance)
            .trackActivity(senting)
            .shareReplay(1)
            .subscribe(
                onNext: { sent in
                    print(sent)
                
                    self.parentPopup?.dismiss(true)
                    self.parentPopup?.didFinishDismissingCompletion = {
                        self.sentHandler?(email!)
                    }
                },
                onError: { error in
                    print("RequestResetPassword failed with error: \(error.localizedDescription)")
                }
            )
            .addDisposableTo(disposeBag)
        
        
        senting.asObservable()
            .subscribe(onNext:{processing in
                print(processing)
                self.sendBtn.isEnabled = !processing
                self.sendBtn.loadingIndicator(show: processing)
                
            })
            .addDisposableTo(disposeBag)
    }
}
