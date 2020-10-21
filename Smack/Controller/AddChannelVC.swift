//
//  AddChannelVC.swift
//  Smack
//
//  Created by Mahesh on 21/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

//    Outlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var channelNameTxt: UITextField!
    @IBOutlet weak var channelDescriptionTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(AddChannelVC.closeTap(_:)))
        self.bgView.addGestureRecognizer(closeTouch)
        
        channelNameTxt.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
        
        channelDescriptionTxt.attributedPlaceholder = NSAttributedString(string: "Description", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceHolder])
    }
    
    @objc func closeTap(_ recognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = channelNameTxt.text, channelNameTxt.text != "" else { return }
        guard let desc = channelDescriptionTxt.text, channelDescriptionTxt.text != "" else { return }
        
        SocketService.instance.addChannel(channelName: name, channelDesc: desc) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
