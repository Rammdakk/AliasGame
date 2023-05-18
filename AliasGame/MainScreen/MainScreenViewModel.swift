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
    
    func logout() {
        
        guard let logoutURL = URL(string: UrlLinks.LOGOUT) else {
            self.errorState = .Error(message: "Logout failed")
            return
        }

        guard let bearerToken = KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self)?.value else {
            self.errorState = .Error(message: "Logout failed")
            return
        }
        
        NetworkManager().makeNonReturningRequest(url: logoutURL, method: .post, parameters: nil, bearerToken: bearerToken) { result in
            switch result {
            case .success():
                KeychainHelper.shared.delete(service: userBearerTokenService, account: account)
                self.errorState = .Succes(message: "You have successfully logout")
                self.isSuccesLogout = true
            case .failure(let error):
                // Handle the error
                self.errorState = .Error(message: "Logout failed: \(error.errorMessage)")
            }
        }

    }
}
