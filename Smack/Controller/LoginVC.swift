//
//  LoginVC.swift
//  Smack
//
//  Created by Mahesh on 15/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
