//
//  GbMagicBuyingShareVC.swift
//  postcraft
//
//  Created by LionStar on 2/3/17.
//  Copyright © 2017 idan. All rights reserved.
//

import UIKit

class GbMagicBuyingShareVC: UIViewController {
    
    var cycle:CycleModel? = nil
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.barStyle = .default

        // Do any additional setup after loading the view.
        
        photoImageView.image = UIImage(named:(cycle?.photo_url)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: @IBActions
    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func shareBtnTapped(_ sender: Any) {
    }
    @IBAction func privateSaveBtnTapped(_ sender: Any) {
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
