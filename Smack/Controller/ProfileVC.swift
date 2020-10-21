//
//  ProfileVC.swift
//  Smack
//
//  Created by Mahesh on 21/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        userEmail.text = UserDataService.instance.email
        userName.text = UserDataService.instance.name
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        let clouseTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        self.bgView.addGestureRecognizer(clouseTouch)
    }
    
    @objc func closeTap(_ recognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
