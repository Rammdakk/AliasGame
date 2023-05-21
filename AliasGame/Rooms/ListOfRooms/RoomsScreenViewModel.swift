//
//  RoomsScreenViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import SwiftUI
import Foundation


class RoomsScreenViewModel: ObservableObject {

    @Published var errorState: ErrorState = .None
    @Published var listOfRooms: [RoomModel] = []
    @Published var navigationState: NavigationState = .Rooms
    
    init() {
        getList()
    }
    
    func getList() {
        // Only for test
//        return getListMocks()
 
        guard let getListUrl = URL(string: UrlLinks.ROOM_LIST) else {
            self.errorState = .Error(message: "URL creation error")
            listOfRooms = []
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            listOfRooms = []
            return
        }
        
        print("called \(bearerToken)")
        NetworkManager().makeRequest(url: getListUrl, method: .get, parameters: nil, bearerToken: bearerToken) { (result: Result<[RoomModel]?, NetworkError>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.listOfRooms = data ?? []
                }
                return
            case .failure(let error):
                // Handle the error
                print(error)
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "Error: \(error.errorMessage)")
                }
            }
        }
    }
    
    // invitationCode = nil, if room is public.
    func joinRoom(roomID: String, invitationCode: String?) {
 
        guard let getListUrl = URL(string: UrlLinks.JOIN_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            listOfRooms = []
            return
        }
        
        print("called \(bearerToken)")
        
        var parameters: [String: Any] = ["gameRoomId": roomID]

        if let invitationCode = invitationCode {
            parameters["invitationCode"] = invitationCode
        }
        
//        self.navigationState = .GameRoom(room: RoomModel(isPrivate: false, id: "81F61C99-9178-4BE9-85E5-343381619FB9", admin: "User1", name: "Room1-public", creator: "User1", invitationCode: "aSwTb", points: 10))
//        return
        NetworkManager().makeRequest(url: getListUrl, method: .post, parameters: parameters, bearerToken: bearerToken) { (result: Result<RoomModel?, NetworkError>) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    DispatchQueue.main.async {
                        self.navigationState = .GameRoom(room: roomData)
                    }
                }
                return
            case .failure(let error):
                // Handle the error
                print(error)
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "Error: \(error.errorMessage)")
                }
            }
        }
    }
    
    func getListMocks() {
        let room1 = RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10)
        let room2 = RoomModel(isPrivate: false, id: "456", admin: "admin2", name: "Room 2", creator: "creator2", invitationCode: nil, points: 10)
        let room3 = RoomModel(isPrivate: false, id: "789", admin: "admin3", name: "Room 3", creator: "creator3", invitationCode: "code3", points: 10)
        let room4 = RoomModel(isPrivate: false, id: "101", admin: "admin4", name: "Room 4", creator: "creator4", invitationCode: nil, points: 10)
        let room5 = RoomModel(isPrivate: false, id: "202", admin: "admin5", name: "Room 5", creator: "creator5", invitationCode: "code5", points: 10)
        let room6 = RoomModel(isPrivate: false, id: "303", admin: "admin6", name: "Room 6", creator: "creator6", invitationCode: nil, points: 10)
        let room7 = RoomModel(isPrivate: false, id: "404", admin: "admin7", name: "Room 7", creator: "creator7", invitationCode: "code7", points: 10)
        listOfRooms = [room1, room2, room3, room4, room5, room6, room7]
    }
}
