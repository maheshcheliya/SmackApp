//
//  MessageService.swift
//  Smack
//
//  Created by Mahesh on 21/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    func findAllChannel(completion : @escaping CompletionHandler) {
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { [self] (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
// Another way to parse json
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                    print(channels)
                    
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let name = item["name"].stringValue
                            let channelDescription = item["description"].stringValue
                            let id = item["_id"].stringValue

                            let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)

                            self.channels.append(channel)
                        }
                        NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil)
                    }
                    
                    
                    
                    completion(true)
                } catch let error {
                    debugPrint("find all channel 1:\(response.result.error as Any)")
                    completion(false)
                }
                
            } else {
                debugPrint("find all channel 2: \(response.result.error as Any)")
                completion(false)
            }
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    func findAllMessagesForChannel(channelId : String, completion : @escaping CompletionHandler) {
        
        Alamofire.request("\(URL_GET_MESSAGES)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { [self] (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timestamp = item["timeStamp"].stringValue
                            

                            let message = Message(message: messageBody, username: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timestamp)

                            self.messages.append(message)
                        }
                        print(self.messages)
//                        NotificationCenter.default.post(name: NOTIFICATION_CHANNELS_LOADED, object: nil)
                    }
                    completion(true)
                } catch let error {
                    debugPrint("find all channel 1:\(response.result.error as Any)")
                    completion(false)
                }
                
            } else {
                debugPrint("find all channel 2: \(response.result.error as Any)")
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
