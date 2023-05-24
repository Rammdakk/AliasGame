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
    @Published var name: String = ""
    
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
        
        let session = URLSession.shared
            
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
        
//        NetworkManager().makeRequest(url: profileUrl, method: .get, parameters: nil, bearerToken: bearerToken) { (result: Result<String?, NetworkError>) in
//            switch result {
//            case .success(let data):
//                if let name = data {
//                    self.name = name
//                    print(self.name)
//                } else {
//                    self.name = "Error loading name.\nPress to reload"
//                }
//            case .failure(let error):
//                // Handle the error
//                DispatchQueue.main.async {
//                    self.name = "22Error loading name.\nPress to reload"
//                    print(error)
//                }
//            }
//        }
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
