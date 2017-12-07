//
//  ViewController.swift
//  gridbrand
//
//  Created by LionStar on 1/6/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.perform(#selector(initScrollView), with:nil, afterDelay:0.1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initScrollView() {
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 3, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
    }
      
    @IBAction func peekingBtnTapped(_ sender: AnyObject) {
        let nc:GbMainNC = storyboard?.instantiateViewController(withIdentifier: "MainNC") as! GbMainNC
        
        present(nc, animated: true, completion: nil)
    }
    @IBAction func loginBtnTapped(_ sender: AnyObject) {
        showLoginPopup { (user) in
            let nc:GbMainNC = self.storyboard?.instantiateViewController(withIdentifier: "MainNC") as! GbMainNC
            
            self.present(nc, animated: true, completion: nil)
        }
    }
    @IBAction func signupBtnTapped(_ sender: AnyObject) {
        showSignupPopup { (user) in
            let nc:GbMainNC = self.storyboard?.instantiateViewController(withIdentifier: "MainNC") as! GbMainNC
            
            self.present(nc, animated: true, completion: nil)
        }
    }
    @IBAction func tsppBtnTapped(_ sender: AnyObject) {
        if let url = URL(string: "https://www.hackingwithswift.com") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    
    func showLoginPopup(callback: @escaping (UserModel) -> Void) {
        
        let loginView = GbLoginView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:247))
        let layout = KLCPopupLayoutMake(.center, .top)
        
        let popup:KLCPopup = KLCPopup(contentView: loginView, showType: .bounceInFromTop, dismissType: .bounceOutToTop, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        loginView.closedHandler = {
            popup.dismiss(true)
        }
        
        loginView.loggedInHandler = { user in
            print("===Logged in user \(user)")
            popup.dismiss(true)
            popup.didFinishDismissingCompletion = {
                callback(user)
            }
        }
        
        popup.show(with: layout)
    }
    
    func showSignupPopup(callback: @escaping (UserModel) -> Void) {
        
        let signupView = GbSignupView(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:454))
        let layout = KLCPopupLayoutMake(.center, .top)
        
        let popup:KLCPopup = KLCPopup(contentView: signupView, showType: .bounceInFromTop, dismissType: .bounceOutToTop, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        signupView.closedHandler = {
            popup.dismiss(true)
        }
        
        signupView.signedUpHandler = { user in
            print("===Signed in user \(user)")
            
            popup.dismiss(true)
            popup.didFinishDismissingCompletion = {
                showSignupEmailSentConfirmPopup(parentView:self.view, email: user.email) { (user) in
                    // Should be removed
                    AppSession.currentUser?.email = user.email
                    AppSession.currentUser?.email_verified = user.email_verified
                    
                    callback(AppSession.currentUser!)
                }
            }
        }
        
        popup.show(with: layout)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        // Change the text accordingly
        if Int(currentPage) == 0{
            
        } else if Int(currentPage) == 1{
            
        } else if Int(currentPage) == 2{
            
        }
    }
}
