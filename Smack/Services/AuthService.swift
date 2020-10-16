//
//  AuthService.swift
//  Smack
//
//  Created by Mahesh on 16/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import Foundation
import Alamofire


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
}
