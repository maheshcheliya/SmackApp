//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Mahesh on 15/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txtPassword.endEditing(true)
        txtEmail.endEditing(true)
        txtUserName.endEditing(true)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    @IBAction func pickAvatarPressed(_ sender: Any) {
        
    }
    
    @IBAction func picBGColorPressed(_ sender: Any) {
        
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = txtEmail.text , txtEmail.text != "" else {
            return
        }
        
        guard let pass = txtPassword.text, txtPassword.text != "" else {
            return
        }
        
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("Registered user")
                AuthService.instance.loginUser(email: email, password: pass) { (success2) in
                    if success2 {
                        print("logged in user: ", AuthService.instance.authToken)
                    }
                }
            }
        }
    }
}
