//
//  GbSignupView.swift
//  postcraft
//
//  Created by LionStar on 1/20/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit
import MRCountryPicker
import SwiftSpinner

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


class GbSignupView: GbCustomView {
    var closedHandler: (() -> Void)? = nil
    var signedUpHandler: ((_ user: UserModel) -> Void)? = nil

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: GbRoundedButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var emailValidLabel: UILabel!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var fullnameValidLabel: UILabel!
    @IBOutlet weak var countryValidLabel: UILabel!
    
    let currentPage = Variable(1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Specify Country Picker
        let countryPicker = MRCountryPicker()
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = false
        //countryPicker.setCountry("US")
        countryTextField.inputView = countryPicker
        
        //
        emailValidLabel.isHidden = true
        passwordValidLabel.isHidden = true
        fullnameValidLabel.isHidden = true
        countryValidLabel.isHidden = true
        
        setupPagingObserver()
        setupSignupObserver()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @IBAction func closeBtnTapped(_ sender: AnyObject) {
        self.closedHandler?()
    }
    private func setupPagingObserver() {
        currentPage.asObservable()
            .subscribe(onNext: { page in
                let x = (page-1) * Int(self.scrollView.frame.size.width)
                self.scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
                
                let title = page==4 ? "Finish" : "Next"
                self.nextBtn.setTitle(title, for: UIControlState.normal)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func setupSignupObserver() {
        
        
    }
    
    @IBAction func nextBtnTapped(_ sender: AnyObject) {
        
        let validationService = GridbrandDefaultValidationService.sharedValidationService
        
        if currentPage.value == 1 {
            Observable.just(emailTextField.text)
                .flatMapLatest { email in
                    return validationService.validateEmail(email!)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(.failed(message: "Error contacting server"))
                }
                .shareReplay(1)
                .subscribe(onNext:{[weak self] result in
                    switch result {
                    case .ok:
                        self?.emailValidLabel.isHidden = true
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        self?.currentPage.value = 2
                        break
                    case .empty:
                        self?.emailValidLabel.isHidden = true
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        break
                    case .validating:
                        self?.emailValidLabel.isHidden = false
                        self?.emailValidLabel.text = result.description
                        self?.nextBtn.isEnabled = false
                        self?.nextBtn.loadingIndicator(show: true)
                        break
                    case .failed:
                        self?.emailValidLabel.isHidden = false
                        self?.emailValidLabel.text = result.description
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        break
                        
                    }
                    })
                .addDisposableTo(disposeBag)
        } else if currentPage.value == 2 {
            Observable.just(passwordTextField.text)
                .map { password in
                    return validationService.validatePassword(password!)
                }
                .shareReplay(1)
                .subscribe(onNext:{[weak self] result in
                    switch result {
                    case .ok:
                        self?.passwordValidLabel.isHidden = true
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        self?.currentPage.value = 3
                        break
                    case .empty:
                        self?.passwordValidLabel.isHidden = true
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        break
                    case .failed:
                        self?.passwordValidLabel.isHidden = false
                        self?.passwordValidLabel.text = result.description
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        break
                    default: break
                    }
                    })
                .addDisposableTo(disposeBag)
        } else if currentPage.value == 3 {
            Observable.just(fullnameTextField.text)
                .map { fullname in
                    return validationService.validateFullname(fullname!)
                }
                .shareReplay(1)
                .subscribe(onNext:{[weak self] result in
                    switch result {
                    case .ok:
                        self?.fullnameValidLabel.isHidden = true
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        self?.currentPage.value = 4
                        break
                    case .empty:
                        self?.fullnameValidLabel.isHidden = true
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        break
                    case .failed:
                        self?.fullnameValidLabel.isHidden = false
                        self?.fullnameValidLabel.text = result.description
                        self?.nextBtn.isEnabled = true
                        self?.nextBtn.loadingIndicator(show: false)
                        break
                    default: break
                    }
                    })
                .addDisposableTo(disposeBag)
        } else if currentPage.value == 4 {
            let country = countryTextField.text
            if country?.characters.count == 0 {
                countryValidLabel.isHidden = false
                return
            }
            
            let signingIn = ActivityIndicator()
            
            let email = emailTextField.text
            let password = passwordTextField.text
            let fullname = fullnameTextField.text
            
            self.endEditing(true)
            SwiftSpinner.show("Connecting to satellite...")
            
            Observable.just(SignupModel(email: email!, password: password!, fullname: fullname!, country: country!))
                .flatMapLatest { data in
                    return GridbrandDefaultAPI.sharedAPI.signup(data: data)
                        .observeOn(MainScheduler.instance)
                        .catchErrorJustReturn(UserModel())
                        .trackActivity(signingIn)
                }
                .flatMapLatest{ user -> Observable<UserModel> in
                    return Observable.just(user)
                }
                .shareReplay(1)
                .subscribe(onNext:{ user in
                    print("Signed in \(user)")
                    self.signedUpHandler?(user)
                })
                .addDisposableTo(disposeBag)
            
            signingIn.asObservable()
                .subscribe(onNext:{processing in
                    print(processing)
                    self.nextBtn.isEnabled = !processing
                    if !processing {
                        SwiftSpinner.hide()
                    }
                    
                })
                .addDisposableTo(disposeBag)
            
        }
    }
    
    @IBAction func backBtnTapped(_ sender: AnyObject) {
        if currentPage.value == 1 {return}
        currentPage.value -= 1
        
    }
}

extension GbSignupView: MRCountryPickerDelegate {
    // a picker item was selected
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        countryTextField.text = name
    }
}
