//
//  AuthService.swift
//  Smack
//
//  Created by Mahesh on 16/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//http://localhost:3005/v1

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.setValue(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken : String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.setValue(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail : String {
        get {
            return defaults.value(forKey: USER_EMAIL_KEY) as! String
        }
        set {
            defaults.setValue(newValue, forKey: USER_EMAIL_KEY)
        }
    }
    
    func registerUser(email : String , password : String, completion : @escaping CompletionHandler) {
        
        let lowerCasedEmail = email.lowercased()
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        let body : [String : Any] = [
            "email" : lowerCasedEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email : String , password : String, completion : @escaping CompletionHandler) {
        
        let lowerCasedEmail = email.lowercased()
        let header = [
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        let body : [String : Any] = [
            "email" : lowerCasedEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                
//                if let json = response.result.value as? Dictionary<String, Any> {
//                    if let user = json["user"] as? String {
//                        self.userEmail = user
//                    }
//                    if let token = json["token"] as? String {
//                        self.authToken = token
//                    }
//                }
                
                guard let data = response.data else {
                    return
                }
                
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
                
                self.isLoggedIn = true
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func createUser(name :String, email : String, avatarName : String, avatarColor : String, completion : @escaping CompletionHandler) {
        
        let lowerCaseEmail = email.lowercased()
        let body : [String : Any ] = [
            "name" : name,
            "email" : lowerCaseEmail,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        let header : [String : String] = [
            "Content-Type" : "application/json; charset=utf-8",
            "Authorization" : "Bearer \(AuthService.instance.authToken)"
        ]
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    
                    let id = json["_id"].stringValue
                    let color = json["avatarColor"].stringValue
                    let avatarName = json["avatarName"].stringValue
                    let email = json["email"].stringValue
                    let name = json["name"].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)   
                    completion(true)
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
}
