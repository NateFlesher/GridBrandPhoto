//
//  GbMagicPurchaseVC.swift
//  postcraft
//
//  Created by LionStar on 2/2/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbMagicPurchaseVC: UIViewController {

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var paypalBtn: GbRoundedButton!
    @IBOutlet weak var visaBtn: GbRoundedButton!
    @IBOutlet weak var cardBtn: GbRoundedButton!
    
    // MARK: - Properties
    var cycle:CycleModel? = nil
    var timer:Timer? = nil
    var counter:TimeInterval? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = GbColor.purple
        self.navigationController?.navigationBar.barStyle = .black

        // Do any additional setup after loading the view.
        self.previewImageView.image = UIImage(named:(self.cycle?.photo_url)!)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        counter = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - @IBAction Methods
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    @IBAction func paypalBtnTapped(_ sender: Any) {
        
    }
    @IBAction func visaBtnTapped(_ sender: Any) {
        
    }
    @IBAction func cardBtnTapped(_ sender: Any) {
        
    }
    @IBAction func loginBtnTapped(_ sender: Any) {
        let view = GbLoadingCycleView(frame: self.view.frame)
        
        let layout = KLCPopupLayoutMake(.center, .center)
        
        let popup:KLCPopup = KLCPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: .dimmed, dismissOnBackgroundTouch: false, dismissOnContentTouch: false)
        
        popup.show(with: layout)
        
        view.loadData(cycle: cycle!, callback: { success in
            popup.dismiss(true)
            
            let vc:GbMagicBuyingShareVC = self.storyboard?.instantiateViewController(withIdentifier: "MagicBuyingShareVC") as! GbMagicBuyingShareVC
            vc.cycle = self.cycle
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
    // MARK: - General Methods
    func updateCounter() {
        if counter == nil {return}
        if(counter == 0) {timer?.invalidate()}
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        self.counterLabel.text = dateFormatter.string(from:Date(timeIntervalSince1970: counter!))
        
        counter = counter! - 1
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
