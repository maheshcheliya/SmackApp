//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Mahesh on 15/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var spinner : UIActivityIndicatorView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgUser: UIImageView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var bgColor : UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDataService.instance.avatarName != "" {
            avatarName = UserDataService.instance.avatarName
            imgUser.image = UIImage(named: avatarName)
            
            if(avatarName.contains("light") && bgColor == nil) {
                imgUser.backgroundColor = .lightGray
            }
        }
    }
    
    func setupView() {
        
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateAccountVC.handleTap))
        view.addGestureRecognizer(tap)
        
    }
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func pickAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func picBGColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        UIView.animate(withDuration: 0.2) {
            self.imgUser.backgroundColor = self.bgColor
        }
        
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
        
        spinner.startAnimating()
        AuthService.instance.registerUser(email: email, password: pass) { (success) in
            if success {
                print("Registered user")
                AuthService.instance.loginUser(email: email, password: pass) { (success2) in
                    if success2 {
//                        print("logged in user: ", AuthService.instance.authToken)
                        
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            self.spinner.stopAnimating()
                            if success {
                                print(UserDataService.instance.name)
                                print(UserDataService.instance.avatarName)
                                
                                self.performSegue(withIdentifier: UNWIND, sender: self)
                                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
