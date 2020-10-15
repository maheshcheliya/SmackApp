//
//  ChannelVC.swift
//  Smack
//
//  Created by Mahesh on 14/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 60
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
}
