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
//        iso 8601
        
        guard var isoDate = message.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoformatter = ISO8601DateFormatter()
        let chatDate = isoformatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let newFinalDate = newFormatter.string(from: finalDate)
            timeStampLabel.text = newFinalDate
        }
    }
}
