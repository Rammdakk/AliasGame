//
//  RoomCreationViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 18.05.2023.
//

import SwiftUI
import Foundation

class RoomCreationViewModel: ObservableObject {
    // Represents the view model for the room creation screen
    
    @Published var errorState: ErrorState = .None
    @Published var navigationState: NavigationState = .RoomCreation
    
    func createRoom(name: String, isPrivate: Bool, teams: [String]) {
        // Function to create a game room
        
        // Check if the room name is too short
        if name.count < 2 {
            errorState = .Error(message: "Too short room name")
            return
        }
        
        // Check if at least 2 teams must be created
        if teams.count < 2 {
            errorState = .Error(message: "At least 2 teams must be created")
            return
        }
        
        // Get the URL for creating the room
        guard let createRoomURL = URL(string: UrlLinks.CREATE_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        
        // Get the bearer token from Keychain
        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        // Set the parameters for the request
        let parameters = ["name": name, "isPrivate": isPrivate] as [String: Any]
        
        // Make a network request to create the room
        NetworkManager().makeRequest(url: createRoomURL, method: .post, parameters: parameters, bearerToken: bearerToken) { (result: Result<GameRoom?, NetworkError>) in
            switch result {
            case .success(let data):
                if let room = data {
                    DispatchQueue.main.async {
                        self.addTeams(teams: teams, room: room, accessToken: bearerToken)
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
    
    private func addTeams(teams: [String], room: GameRoom, accessToken: String) {
        // Function to add teams to the room
        
        let group = DispatchGroup()
        
        // Get the URL for adding a team
        guard let addTeamURL = URL(string: UrlLinks.ADD_TEAM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        
        teams.forEach { team in
            let parameters = ["name": team, "gameRoomId": room.id] as [String: Any]
            group.enter()
            
            // Make a network request to add the team
            NetworkManager.shared.makeNonReturningRequest(url: addTeamURL, method: .post, parameters: parameters, bearerToken: accessToken) { result in
                switch result {
                case .success():
                    print("team created: \(team)")
                case .failure(let error):
                    print("team created: \(error)")
                    DispatchQueue.main.async {
                        self.errorState = .Error(message: "Error in adding team:\n\(error.errorMessage)")
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            print("All tasks have finished!")
            self.joinRoom(roomID: room.id, invitationCode: room.invitationCode, accessToken: accessToken)
            // Perform any additional actions after all tasks have finished
        }
    }
    
    private func joinRoom(roomID: String, invitationCode: String?, accessToken: String) {
        // Function to join the room
        
        guard let joinRoomURL = URL(string: UrlLinks.JOIN_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        
        var parameters: [String: Any] = ["gameRoomId": roomID]
        
        if let invitationCode = invitationCode {
            parameters["invitationCode"] = invitationCode
        }
        
        // Make a network request to join the room
        NetworkManager().makeRequest(url: joinRoomURL, method: .post, parameters: parameters, bearerToken: accessToken) { (result: Result<RoomModel?, NetworkError>) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(roomData.id, forKey: UserDefaultsKeys.USER_ROOM_KEY)
                        UserDefaults.standard.set(roomData.invitationCode, forKey: UserDefaultsKeys.ROOM_INVIT_KEY)
                        self.errorState = .Succes(message: "Room \(roomData.name) successfully created")
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
}
