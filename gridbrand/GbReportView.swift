//
//  GbReportView.swift
//  postcraft
//
//  Created by LionStar on 1/26/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
#endif

enum ReportOption {
    case copyright
    case content
    case magicshop
}

class GbReportView: GbCustomView {
    var parentPopup: KLCPopup? = nil
    
    var cycle: CycleModel? = nil
    
    var completionHandler: ((_ result:Bool) -> Void)? = nil

    @IBOutlet weak var submitBtn: GbRoundedButton!
    @IBOutlet weak var cancelBtn: GbRoundedButton!
    
    @IBOutlet weak var optionImageView1: UIImageView!
    @IBOutlet weak var optionImageView2: UIImageView!
    @IBOutlet weak var optionImageView3: UIImageView!
    
    @IBAction func optionBtn1Tapped(_ sender: AnyObject) {
        selectOption(option: .copyright)
    }

    @IBAction func optionBtn2Tapped(_ sender: AnyObject) {
        selectOption(option: .content)
    }
    @IBAction func optionBtn3Tapped(_ sender: AnyObject) {
        selectOption(option: .magicshop)
    }
    
    func selectOption(option:ReportOption) {
        optionImageView1.image = UIImage(named:option == .copyright ? "radio_selected" : "radio")
        optionImageView2.image = UIImage(named:option == .content ? "radio_selected" : "radio")
        optionImageView3.image = UIImage(named:option == .magicshop ? "radio_selected" : "radio")
    }
    @IBAction func submitBtnTapped(_ sender: AnyObject) {
        let disposeBag = DisposeBag()
        let submitting = ActivityIndicator()
        GridbrandDefaultAPI.sharedAPI.reportCycle(cycleId: (cycle?.id)!)
            .observeOn(MainScheduler.instance)
            .trackActivity(submitting)
            .subscribe(
                onNext:{result in
                    self.parentPopup?.dismiss(true)
                    self.completionHandler?(result)
                },
                onError: { err in
                    print(err)
                    self.view.makeToast(err.localizedDescription)
                }
            )
            .addDisposableTo(DisposeBag())
        
        
        submitting.asObservable()
            .subscribe(onNext:{processing in
                print(processing)
                self.submitBtn.isEnabled = !processing
                self.cancelBtn.isEnabled = !processing
                
                self.submitBtn.loadingIndicator(show: processing)
                
            })
            .addDisposableTo(disposeBag)
    }
    @IBAction func cancelBtnTapped(_ sender: AnyObject) {
        parentPopup?.dismiss(true)
    }
}
