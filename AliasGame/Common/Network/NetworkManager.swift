//
//  NetworkManager.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
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
                  completion(.success(()))
              } else {
                  completion(.failure(.invalidResponse("Request failed with status code: \(httpResponse.statusCode)")))
              }
          }.resume()
      }
    
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
                        completion(.success(decodedResponse))
                    } catch {
                        print(error)
                        completion(.failure(.decodingFailed))
                    }
                } else {
                    completion(.success(nil))
                }
            } else {
                completion(.failure(.invalidResponse("Request failed with status code: \(httpResponse.statusCode)")))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case noData
    case decodingFailed
    case invalidRequest(String)
    case networkError(String)
    case invalidResponse(String)
    
    var errorMessage: String {
        switch self {
        case .noData:
            return "No data received."
        case .decodingFailed:
            return "Failed to decode response data."
        case .invalidRequest(let message), .networkError(let message):
            return "Error: \(message)"
        case .invalidResponse(let statusCode):
            return "Invalid response with status code: \(statusCode)"
        }
    }
}
