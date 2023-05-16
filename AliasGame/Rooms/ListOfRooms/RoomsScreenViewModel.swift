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
    
    init() {
        getList()
    }
    
    func getList() {
 
        guard let getListUrl = URL(string: UrlLinks.ROOM_LIST) else {
            self.errorState = .Error(message: "Logout failed")
            listOfRooms = []
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Logout failed")
            listOfRooms = []
            return
        }
        
        
        print("called \(bearerToken)")
        NetworkManager().makeRequest(url: getListUrl, method: .get, parameters: nil, bearerToken: bearerToken) { (result: Result<[RoomModel]?, NetworkError>) in
            switch result {
            case .success(let data):
                self.listOfRooms = data ?? []
                return
            case .failure(let error):
                // Handle the error
                print(error)
                self.errorState = .Error(message: "Logout failed: \(error.errorMessage)")
            }
        }

    }
}
