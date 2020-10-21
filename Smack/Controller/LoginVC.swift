//
//  LoginVC.swift
//  Smack
//
//  Created by Mahesh on 15/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    //Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        spinner.startAnimating()
        
        guard let email = txtEmail.text, email != "" else { return }
        guard let password = txtPassword.text, password != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail { (success) in
                    self.spinner.stopAnimating()
                    if success {
                        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
