//
//  MainScreenViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import SwiftUI
import Foundation


class MainScreenViewModel: ObservableObject {

    @Published var errorState: ErrorState = .None
    @Published var isSuccesLogout = false
    @Published var isInRoom: RoomModel? = nil
    @Published var name: String = ""
    
    init() {
        self.errorState = .None
        self.isSuccesLogout = false
        self.name = ""
        self.isInRoom = nil
        let roomID = UserDefaults.standard.string(forKey: UserDefaultsKeys.USER_ROOM_KEY)
        let invCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.ROOM_INVIT_KEY)
        print(roomID)
        if( roomID != nil ) {
            joinRoom(roomID: roomID!, invitationCode: invCode)
        }
    }
    
    private func joinRoom(roomID: String, invitationCode: String?) {
        // Function to join the room
        
        guard let getRoomURL = URL(string: UrlLinks.GET_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        
        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            DispatchQueue.main.async {
                self.name = "Error loading name.\nPress to reload"
                print(self.name)
            }
            return
        }
        
        var parameters: [String: Any] = ["gameRoomId": roomID]
        
        if let invitationCode = invitationCode {
            parameters["invitationCode"] = invitationCode
        }
        
        // Make a network request to join the room
        NetworkManager().makeRequest(url: getRoomURL, method: .post, parameters: parameters, bearerToken: bearerToken) { (result: Result<RoomModel?, NetworkError>) in
            switch result {
            case .success(let data):
                if let roomData = data {
                    DispatchQueue.main.async {
                        self.isInRoom = roomData
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
    
    func profile() {
        guard let profileUrl = URL(string: UrlLinks.PROFILE) else {
            DispatchQueue.main.async { [self] in
                name = "Error loading name.\nPress to reload"
                print(name)
            }
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            DispatchQueue.main.async {
                self.name = "Error loading name.\nPress to reload"
                print(self.name)
            }
            return
        }
        
        var request = URLRequest(url: profileUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            
            // Create a data task using the URL
        URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Check for any errors
                if let error = error {
                    self.name = "Error loading name.\nPress to reload"
                    print("Error: \(error)")
                    return
                }
                
                // Ensure the response contains data
                guard let responseData = data else {
                    self.name = "Error loading name.\nPress to reload"
                    print("Error: ")
                    return
                }
                
                // Convert the response data to a string
                if let responseString = String(data: responseData, encoding: .utf8) {
                    // Handle the string response
                    DispatchQueue.main.async {
                        self.name = responseString
                        print(self.name)
                    }
                }
            }.resume()
    }
    
    func logout() {
        guard let logoutURL = URL(string: UrlLinks.LOGOUT) else {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Logout failed")
            }
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            DispatchQueue.main.async {
                self.errorState = .Error(message: "Logout failed")
            }
            return
        }
        
        NetworkManager().makeNonReturningRequest(url: logoutURL, method: .post, parameters: nil, bearerToken: bearerToken) { result in
            switch result {
            case .success():
                KeychainHelper.shared.delete(service: userBearerTokenService, account: account)
                DispatchQueue.main.async {
                    self.errorState = .Succes(message: "You have successfully logout")
                    self.isSuccesLogout = true
                }
            case .failure(let error):
                // Handle the error
                DispatchQueue.main.async {
                    self.errorState = .Error(message: "Logout failed: \(error.errorMessage)")
                }
            }
        }
    }
}
