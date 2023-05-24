//
//  UrlLinks.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

class UrlLinks {

    static let BASE_URL = "http://127.0.0.1:8080"
    
    // Auth
    static let LOGIN = "\(BASE_URL)/users/login"
    static let REGISTER = "\(BASE_URL)/users/register"
    static let LOGOUT = "\(BASE_URL)/users/logout"
    static let PROFILE = "\(BASE_URL)/users/profile"
    
    // Rooms
    static let CREATE_ROOM = "\(BASE_URL)/game-rooms/create"
    static let ROOM_LIST = "\(BASE_URL)/game-rooms/list-all"
    static let JOIN_ROOM = "\(BASE_URL)/game-rooms/join-room"
    static let EDIT_ROOM = "\(BASE_URL)/game-rooms/change-setting"
    static let LEAVE_ROOM = "\(BASE_URL)/game-rooms/leave-room"
    static let PASS_ADMIN = "\(BASE_URL)/game-rooms/pass-admin-status"
    
    // Teams
    static let TEAMS_LIST = "\(BASE_URL)/teams/list-teams"
    static let JOIN_TEAM = "\(BASE_URL)/teams/join-team"
}
