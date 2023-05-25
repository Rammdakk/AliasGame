//  GameRoomScreenViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 21.05.2023.
//

import SwiftUI
import Foundation


class GameRoomScreenViewModel: ObservableObject {
    // ViewModel for the game room screen
    
    @Published var errorState: ErrorState = .None
    @Published var navigationState: NavigationState
    @Published var teams: [TeamModel] = []
    
    // MARK: - Initialization
    
    init(navigationState: NavigationState) {
        // Initialize the ViewModel with the provided navigation state
        
        self.errorState = .None
        self.navigationState = navigationState
        self.teams = []
    }
    
    // MARK: - Functions
    
    func leaveRoom(roomID: String) {
        // Method for leaving the game room
        
        guard var leaveRoomUrl = URL(string: UrlLinks.LEAVE_ROOM) else {
            // Check if the URL creation fails, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            // Check if the bearer token is not available, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let queryItems = [URLQueryItem(name: "gameRoomId", value: roomID)]
        leaveRoomUrl.append(queryItems: queryItems)
        print(leaveRoomUrl)
        
        NetworkManager().makeNonReturningRequest(url: leaveRoomUrl, method: .get, parameters: nil, bearerToken: bearerToken) { result in
            switch result {
            case .success:
                // If the request is successful, update the navigationState to .Main and set the errorState to .Success with a message
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
    
    func loadTeams(roomID: String) {
        // Method for loading teams in the game room
        
        guard var loadTeamsURl = URL(string: UrlLinks.TEAMS_LIST) else {
            // Check if the URL creation fails, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            // Check if the bearer token is not available, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let queryItems = [URLQueryItem(name: "gameRoomId", value: roomID)]
        loadTeamsURl.append(queryItems: queryItems)
        
        NetworkManager().makeRequest(url: loadTeamsURl, method: .get, parameters: nil, bearerToken: bearerToken) { (result: Result<[TeamModel]?, NetworkError>) in
            switch result {
            case .success(let data):
                // If the request is successful, update the teams array with the received data
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
    
    func joinTeam(teamID: String, roomID: String) {
        // Method for joining a team in the game room
        
        guard let joinTeam = URL(string: UrlLinks.JOIN_TEAM) else {
            // Check if the URL creation fails, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            // Check if the bearer token is not available, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let parameters = ["teamId": teamID] as [String : Any]
        print(joinTeam)
        
        NetworkManager().makeNonReturningRequest(url: joinTeam, method: .post, parameters: parameters, bearerToken: bearerToken) { result in
            switch result {
            case .success:
                // If the request is successful, call loadTeams to update the teams array
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
    
    func passAdmin(newAdminID: String, roomID: String) {
        // Method for passing the admin role to another user
        
        guard let passAdminURL = URL(string: UrlLinks.PASS_ADMIN) else {
            // Check if the URL creation fails, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "URL creation error")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            // Check if the bearer token is not available, set the errorState to .Error with a message and return
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        let parameters = ["gameRoomId": roomID, "newAdminId": newAdminID] as [String : Any]
        NetworkManager().makeNonReturningRequest(url: passAdminURL, method: .post, parameters: parameters, bearerToken: bearerToken) { result in
            switch result {
            case .success:
                // If the request is successful, call loadTeams to update the teams array
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


