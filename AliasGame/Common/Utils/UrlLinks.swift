//
//  UrlLinks.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

class UrlLinks {
    // Base url made by ngrok, just for testing.
    static let BASE_URL = "https://a595-188-35-131-222.eu.ngrok.io"
    
    // Auth
    static let LOGIN = "\(BASE_URL)/users/login"
    static let REGISTER = "\(BASE_URL)/users/register"
    static let LOGOUT = "\(BASE_URL)/users/logout"
    
    // Rooms
    static let ROOM_LIST = "\(BASE_URL)/game-rooms/list-all"
}
