//
//  NetworkManager.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // Make a network request without getting data.
    func makeNonReturningRequest(url: URL, method: HTTPMethod, parameters: [String: Any]?, bearerToken: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
          var request = URLRequest(url: url)
          request.httpMethod = method.rawValue
          request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
          
          if let parameters = parameters {
              do {
                  let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                  request.httpBody = jsonData
              } catch {
                  completion(.failure(.invalidRequest("Failed to serialize request parameters: \(error)")))
                  return
              }
          }
          
          URLSession.shared.dataTask(with: request) { data, response, error in
              if let error = error {
                  completion(.failure(.networkError(error.localizedDescription)))
                  return
              }
              
              guard let httpResponse = response as? HTTPURLResponse else {
                  completion(.failure(.invalidResponse("Invalid response")))
                  return
              }
              
              if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                  completion(.success(()))  // Request succeeded
              } else {
                  completion(.failure(.invalidResponse(self.getErrorMessage(code: httpResponse.statusCode))))
              }
          }.resume()
      }
    
    // Make a network request with a data response type
    func makeRequest<T: Decodable>(url: URL, method: HTTPMethod, parameters: [String: Any]?, bearerToken: String, completion: @escaping (Result<T?, NetworkError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch {
                completion(.failure(.invalidRequest("Failed to serialize request parameters: \(error)")))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse("Invalid response")))
                return
            }
            
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                // Check if the response should contain data
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        guard let jsonString = String(data: data, encoding: .utf8) else {
                            print("Failed to convert response data to string")
                            return
                        }
                        print(jsonString)
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        completion(.success(decodedResponse)) // Request succeeded with a decoded response
                    } catch {
                        print(error)
                        completion(.failure(.decodingFailed)) // Failed to decode the response
                    }
                } else {
                    completion(.success(nil)) // Request succeeded with no data
                }
            } else {
                completion(.failure(.invalidResponse(self.getErrorMessage(code: httpResponse.statusCode)))) // Request failed with an error
            }
        }.resume()
    }
    
    // Get the error message for a given status code
    func getErrorMessage(code: Int) -> String {
        let errorMessage: String
        switch code {
        case 400:
            errorMessage = "Bad Request"
        case 401:
            errorMessage = "Unauthorized."
        case 403:
            errorMessage = "Forbidden. You don't have rights to do it."
        case 404:
            errorMessage = "Not Found"
        case 500:
            errorMessage = "Internal Server Error"
        default:
            errorMessage = "Request failed with status code: \(code)"
        }
        return errorMessage
    }
}
