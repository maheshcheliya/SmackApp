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


//Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

// USER DEFAULTS
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL_KEY = "userEmail"

// mlab database config
//username : mahesh
//password : Mahesh123456

//MongoDB URI = mongodb+srv://mahesh:<password>@cluster0.1ymmn.mongodb.net/<dbname>?retryWrites=true&w=majority
