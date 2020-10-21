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
}
