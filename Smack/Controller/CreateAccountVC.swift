//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Mahesh on 15/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
}
