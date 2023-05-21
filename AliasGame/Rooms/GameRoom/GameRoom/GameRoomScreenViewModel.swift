//
//  GameRoomScreenViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 21.05.2023.
//

import SwiftUI
import Foundation


class GameRoomScreenViewModel: ObservableObject {

    @Published var errorState: ErrorState = .None
    @Published var navigationState: NavigationState
    @Published var teams: [TeamModel] = []
    
    init(navigationState: NavigationState) {
        self.errorState = .None
        self.navigationState = navigationState
        self.teams = []
    }
    
    func leaveRoom(roomID:String) {
 
        guard var leaveRoomUrl = URL(string: UrlLinks.LEAVE_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let queryItems = [URLQueryItem(name: "gameRoomId", value: roomID)]
        leaveRoomUrl.append(queryItems: queryItems)
        print(leaveRoomUrl)
        NetworkManager().makeNonReturningRequest(url: leaveRoomUrl, method: .get, parameters: nil, bearerToken: bearerToken) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.navigationState = .Main
                    self.errorState = .Succes(message: "You left room")
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
    
    func loadTeams(roomID:String) {
         guard var loadTeamsURl = URL(string: UrlLinks.TEAMS_LIST) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let queryItems = [URLQueryItem(name: "gameRoomId", value: roomID)]
        loadTeamsURl.append(queryItems: queryItems)
        
        NetworkManager().makeRequest(url: loadTeamsURl, method: .get, parameters: nil, bearerToken: bearerToken) { (result: Result<[TeamModel]?, NetworkError>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.teams = data ?? []
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
    
    func joinTeam(teamID:String, roomID:String) {
         guard var joinTeam = URL(string: UrlLinks.JOIN_TEAM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let parameters = ["teamId": teamID] as [String : Any]
        print(joinTeam)
        NetworkManager().makeNonReturningRequest(url: joinTeam, method: .post, parameters: parameters, bearerToken: bearerToken) { result in
            switch result {
            case .success:
                self.loadTeams(roomID: roomID)
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


