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
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    
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
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func picBGColorPressed(_ sender: Any) {
        
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        guard let name = txtUserName.text, txtUserName.text != "" else {
            return
        }
        
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
//                        print("logged in user: ", AuthService.instance.authToken)
                        
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            if success {
                                print(UserDataService.instance.name)
                                print(UserDataService.instance.avatarName)
                                
                                self.performSegue(withIdentifier: UNWIND, sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
}
