//
//  AuthViewModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

import SwiftUI
import Foundation


class AuthViewModel: ObservableObject {
    
    init() {
        if (KeychainHelper.shared.read(service: userBearerTokenService, account: account, type: LoginResponse.self) != nil)  {
            isSuccesAuth = true
        }
    }
    private let succesLoginMessage = "You have successfully logged in"
    @Published var showLogin = false
    @Published var showRegister = false
    @Published var isSuccesAuth = false
    @Published var errorState: ErrorState = .None
    
    func login(email: String, password: String) {
        guard let url = URL(string: UrlLinks.LOGIN) else {
            return
        }
        let parameters = ["email": email, "password": password]
        performNetworkRequest(url: url, method: .post, parameters: parameters) { data in
                   // Process login response data
                   do {
                       let decoder = JSONDecoder()
                       let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                       print("Login response:")
                       print("Value: \(loginResponse.value)")
                       print("ID: \(loginResponse.id)")
                       print("User ID: \(loginResponse.user.id)")
                       UserDefaults.standard.set(loginResponse.user.id, forKey: UserDefaultsKeys.USER_ID_KEY)
                       try KeychainHelper.shared.save(loginResponse, service: userBearerTokenService, account: account)
                       DispatchQueue.main.async {
                           self.errorState = .Succes(message: self.succesLoginMessage)
                           self.isSuccesAuth = true
                       }
                   } catch {
                       print("Error decoding login response: \(error)")
                       DispatchQueue.main.async {
                           self.errorState = .Error(message: error.localizedDescription)
                       }
                   }
               }
    }
    
    func register(email: String, password: String, username: String) {
        guard let url = URL(string: UrlLinks.REGISTER) else {
            return
        }
        let parameters = ["email": email, "password": password, "name": username]
        performNetworkRequest(url: url, method: .post, parameters: parameters) { data in
            // Process register response data
            do {
                let decoder = JSONDecoder()
                let registerResponse = try decoder.decode(RegisterResponse.self, from: data)
                print("Register response:")
                print("Email: \(registerResponse.email)")
                print("ID: \(registerResponse.id)")
                print("Name: \(registerResponse.name)")
                print("Password Hash: \(registerResponse.passwordHash)")
                self.login(email: email, password: password)
            } catch {
                print("Error decoding register response: \(error)")
                DispatchQueue.main.async {
                    self.errorState = .Error(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func performNetworkRequest(url: URL, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Data) -> Void) {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorState = .Error(message: error.localizedDescription)
                    }
                    print("Error: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                completion(data)
            }.resume()
        }
}
