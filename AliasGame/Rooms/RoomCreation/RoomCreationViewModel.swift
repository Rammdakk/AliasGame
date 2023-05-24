//
//  RoomCreationViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 18.05.2023.
//

import SwiftUI
import Foundation


class RoomCreationViewModel: ObservableObject {

    @Published var errorState: ErrorState = .None
    @Published var navigationState: NavigationState = .RoomCreation

    
    func createRoom(name: String, isPrivate: Bool, teams: [String]) {
        if (name.count < 2) {
            errorState = .Error(message: "Too short room name")
            return
        }
        
        if (teams.count < 2){
            errorState = .Error(message: "At least 2 teams must be created")
            return
        }
 
        guard let getListUrl = URL(string: UrlLinks.CREATE_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let parameters = ["name": name, "isPrivate": isPrivate] as [String : Any]
        
        NetworkManager().makeRequest(url: getListUrl, method: .post, parameters: parameters, bearerToken: bearerToken) { (result: Result<GameRoom?, NetworkError>) in
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
    
    private func addTeams(teams:[String], room: GameRoom, accessToken: String){
        let group = DispatchGroup()
        guard let addTeam = URL(string: UrlLinks.ADD_TEAM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        teams.forEach { team in
            let parameters = ["name": team, "gameRoomId": room.id] as [String : Any]
            group.enter()
            NetworkManager.shared.makeNonReturningRequest(url: addTeam, method: .post, parameters: parameters, bearerToken: accessToken) { result in
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
 
        guard let getListUrl = URL(string: UrlLinks.JOIN_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }

        
        var parameters: [String: Any] = ["gameRoomId": roomID]

        if let invitationCode = invitationCode {
            parameters["invitationCode"] = invitationCode
        }
        
        NetworkManager().makeRequest(url: getListUrl, method: .post, parameters: parameters, bearerToken: accessToken) { (result: Result<RoomModel?, NetworkError>) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    DispatchQueue.main.async {
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
