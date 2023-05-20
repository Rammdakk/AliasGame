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

    
    func createRoom(name: String, isPrivate: Bool) {
//        // Only for test
//        return getListMocks()
 
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
                if let name = data?.name {
                    DispatchQueue.main.async {
                        self.errorState = .Succes(message: "Room \(name) successfully created")
                        self.navigationState = .Main
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
