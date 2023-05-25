//
//  RoomsScreenViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import SwiftUI
import Foundation

class RoomsScreenViewModel: ObservableObject {
    
    // Published properties for updating the view when their values change
    @Published var errorState: ErrorState = .None
    @Published var listOfRooms: [RoomModel] = []
    @Published var navigationState: NavigationState = .Rooms
    
    // Initializer called when an instance of RoomsScreenViewModel is created
    init() {
        // Call the getList() method to retrieve the list of rooms
        getList()
    }
    
    // Method for retrieving the list of rooms from the server
    func getList() {
        // Only for test
        // return getListMocks()
        
        // Check if the URL for fetching the list of rooms can be created
        guard let getListUrl = URL(string: UrlLinks.ROOM_LIST) else {
            self.errorState = .Error(message: "URL creation error")
            listOfRooms = []
            return
        }
        
        // Retrieve the bearer token from the Keychain
        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            listOfRooms = []
            return
        }
        
        print("called \(bearerToken)")
        
        // Make a network request to get the list of rooms
        NetworkManager().makeRequest(url: getListUrl, method: .get, parameters: nil, bearerToken: bearerToken) { (result: Result<[RoomModel]?, NetworkError>) in
            switch result {
            case .success(let data):
                // Update the listOfRooms property with the retrieved data (if any)
                DispatchQueue.main.async {
                    self.listOfRooms = data ?? []
                }
                return
            case .failure(let error):
                // Handle the error by setting the errorState property
                print(error)
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "Error: \(error.errorMessage)")
                }
            }
        }
    }
    
    // Method for joining a room
    // invitationCode is nil if the room is public
    func joinRoom(roomID: String, invitationCode: String?) {
        
        // Check if the URL for joining a room can be created
        guard let getListUrl = URL(string: UrlLinks.JOIN_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        
        // Retrieve the bearer token from the Keychain
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
        
        // Make a network request to join the room
        NetworkManager().makeRequest(url: getListUrl, method: .post, parameters: parameters, bearerToken: bearerToken) { (result: Result<RoomModel?, NetworkError>) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    // Update the navigationState property to navigate to the game room
                    DispatchQueue.main.async {
                        self.navigationState = .GameRoom(room: roomData)
                    }
                }
                return
            case .failure(let error):
                // Handle the error by setting the errorState property
                print(error)
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "Error: \(error.errorMessage)")
                }
            }
        }
    }
    
    // Method for creating a mock list of rooms (for testing purposes)
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
