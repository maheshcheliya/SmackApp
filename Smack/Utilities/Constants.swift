//
//  Constants.swift
//  Smack
//
//  Created by Mahesh on 15/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ success: Bool) -> ()

//URL Constants
//let BASE_URL = "http://localhost:3005/v1/"
let BASE_URL = "http://192.168.2.26:3005/v1/"

let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_USER_ADD = "\(BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(BASE_URL)user/byemail/"
//Colors
let smackPurplePlaceHolder = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5)

//Notification constants
let NOTIFICATION_USER_DATA_DID_CHANGE = Notification.Name(rawValue: "notificationUserDataChanged")

//Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let TO_AVATAR_PICKER = "toAvatarPicker"

let UNWIND = "unwindToChannel"


// USER DEFAULTS
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL_KEY = "userEmail"



//Headers
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]


let BEARER_HEADER : [String : String] = [
    "Content-Type" : "application/json; charset=utf-8",
    "Authorization" : "Bearer \(AuthService.instance.authToken)"
]

// mlab database config
//username : mahesh
//password : Mahesh123456

//MongoDB URI = mongodb+srv://mahesh:<password>@cluster0.1ymmn.mongodb.net/<dbname>?retryWrites=true&w=majority
