//
//  MessageCell.swift
//  Smack
//
//  Created by Mahesh on 27/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

//    Outlets
    
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message : Message) {
        messageBodyLabel.text = message.message
        userNameLabel.text = message.username
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    }
}
