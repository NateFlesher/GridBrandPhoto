//
//  GbSignupEmailSentView.swift
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


class GbResetPasswordEmailSentView: GbCustomView {
    var parentPopup: KLCPopup? = nil
    
    
    let disposeBag = DisposeBag()
    
    var email: String? = nil
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sendAgainBtn: GbRoundedButton!
    @IBOutlet weak var confirmBtn: GbRoundedButton!
    
    @IBAction func sendAgainBtnTapped(_ sender: AnyObject) {
        if email == nil {return}
        
        let senting = ActivityIndicator()
        
        GridbrandDefaultAPI.sharedAPI.requestResetPassword(email: email!)
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(false)
            .trackActivity(senting)
            .shareReplay(1)
            .subscribe(onNext: { sent in
                print(sent)
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
        self.parentPopup?.dismiss(true)
    }
}
