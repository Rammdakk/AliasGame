//  SettingsViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 20.05.2023.
//

import SwiftUI
import Foundation

class SettingsViewModel: ObservableObject {
    // Represents the view model for configuring game room settings
    
    @Published var errorState: ErrorState = .None
    @Published var newRoom: RoomModel? = nil
    
    func createRoom(roomID: String, newName: String, isPrivate: Bool, points: Int) {
        // Method for updating room settings
        
        // Create the URL for the API endpoint
        guard let getListUrl = URL(string: UrlLinks.EDIT_ROOM) else {
            self.errorState = .Error(message: "URL creation error")
            return
        }
        
        // Get the bearer token from the keychain
        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Access denied")
            return
        }
        
        // Prepare the request parameters
        let parameters = [
            "gameRoomId": roomID,
            "isPrivate": isPrivate,
            "name": newName,
            "points": points
        ] as [String : Any]
        
        // Make the network request to update the room settings
        NetworkManager().makeRequest(url: getListUrl, method: .post, parameters: parameters, bearerToken: bearerToken) { (result: Result<RoomModel?, NetworkError>) in
            switch result {
            case .success(let data):
                // Handle the successful response
                if let room = data {
                    DispatchQueue.main.async {
                        self.errorState = .Succes(message: "Room \(room.name) successfully changed")
                        self.newRoom = RoomModel(isPrivate: room.isPrivate, id: room.id, admin: room.admin, name: room.name, creator: room.creator, invitationCode: room.invitationCode, points: points)
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
