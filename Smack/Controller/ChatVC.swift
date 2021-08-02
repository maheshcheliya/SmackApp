//
//  ChatVC.swift
//  Smack
//
//  Created by Mahesh on 14/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

//    Outlets
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var typingUserLabel: UILabel!
    
//    variables
    var searchTimer: Timer?
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.estimatedRowHeight = 80
        tblView.rowHeight = UITableView.automaticDimension
        
        sendBtn.isHidden = true
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatVC.handleTap(recognizer:)))
        view.addGestureRecognizer(tap)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController()?.tapGestureRecognizer())!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIFICATION_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIFICATION_USER_DATA_DID_CHANGE, object: nil)
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            
            var names = ""
            var numberOfTypers = 0
            
            for(typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names ), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0, AuthService.instance.isLoggedIn == true {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                self.typingUserLabel.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUserLabel.text = ""
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.instance.selectedChannel?.id &&  AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.tblView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let index = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tblView.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }
        }
        
//        SocketService.instance.getChatMessage { (success) in
//            if success {
//                self.tblView.reloadData()
//                if MessageService.instance.messages.count > 0 {
//                    let index = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.tblView.scrollToRow(at: index, at: .bottom, animated: true)
//                }
//            }
//        }
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
//
//        if messageTxtBox.text == "" {
//            isTyping = false
//            sendBtn.isHidden = true
//            SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
//        } else {
//            if isTyping == false {
//                isTyping = true
//            }
//            sendBtn.isHidden = false
//            SocketService.instance.socket.emit("startType", UserDataService.instance.name,channelId)
//        }
        
        if messageTxtBox.text != "" {
            if isTyping == false {
                isTyping = true
            }
            sendBtn.isHidden = false
            SocketService.instance.socket.emit("startType", UserDataService.instance.name,channelId)
        } else {
            sendBtn.isHidden = true
        }
        
        // if a timer is already active, prevent it from firing
        if searchTimer != nil {
            searchTimer?.invalidate()
            searchTimer = nil
        }

        // reschedule the search: in 1.0 second, call the typingChange method on the new textfield content
        searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ChatVC.typingChange(_:)), userInfo: messageTxtBox.text!, repeats: false)
    }
    
    @objc func typingChange(_ timer: Timer) {

        // retrieve the keyword from user info
//        guard let keyword = timer.userInfo as? String else { return }
//        print("Searching for keyword \(keyword)")
        
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        isTyping = false
        SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
    }
    
    @objc func handleTap(recognizer : UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif : Notification) {
        if AuthService.instance.isLoggedIn {
//            get channels
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
            tblView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notifi : Notification) {
        updateWithChannel()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                DispatchQueue.main.async {
                    
            
                if success {
                    self.messageTxtBox.text = ""
                    self.messageTxtBox.resignFirstResponder()
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
                }
                }
            }
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? "Please Log In"
        
        channelNameLbl.text = channelName
        self.getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels.first
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channel yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    if(MessageService.instance.messages.count > 1) {
                        let index = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                        self.tblView.scrollToRow(at: index, at: .bottom, animated: true)
                    }
                }
            }
        }
    }
}

extension ChatVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        return UITableViewCell()
    }
}
