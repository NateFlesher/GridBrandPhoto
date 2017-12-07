//
//  GbMagicPurchaseConfirmView.swift
//  postcraft
//
//  Created by LionStar on 2/2/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

import RxSwift


class GbLoadingCycleView: GbCustomView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var avatarImageView: GbRoundedImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView.addBlurEffect()
        photoImageView.layer.cornerRadius = 6
        photoImageView.clipsToBounds = true

        progressBar.progress = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadData(cycle:CycleModel, callback:@escaping (_ sucess:Bool)->Void) {
        avatarImageView.image = UIImage(named:cycle.user().avatar_url)
        photoImageView.image = UIImage(named:cycle.photo_url)
        
//        let disposeBag = DisposeBag()
//        let downloading = ActivityIndicator()
//        GridbrandDefaultAPI.sharedAPI.requestEmailVerify(accessToken: AppSession.accessToken ?? "f1c9b748-c37a-4348-9b15-1f5f9c6297ce")
//            .observeOn(MainScheduler.instance)
//            .catchErrorJustReturn(false)
//            .trackActivity(downloading)
//            .subscribe(onNext:{ (completed:Bool) in
//                callback(completed)
//            }, onError: { error in
//                print(error)
//            })
//            .addDisposableTo(disposeBag)
//        
//        
//        downloading.asObservable()
//            .subscribe(onNext:{finished in
//                print(finished)
//                
//            })
//            .addDisposableTo(disposeBag)
        
        GridbrandDefaultAPI.sharedAPI.downloadCycleData(accessToken: "asdfasdf")
            .downloadProgress { progress in
                debugPrint("Download progress \(progress)")
                self.progressBar.progress = Float(progress.fractionCompleted)
            }
            .responseData { response in
                debugPrint(response)
                
                if let data = response.result.value {
                    callback(true)
                } else {
                    print("Data was invalid")
                    callback(false)
                }
        }
    }
}
