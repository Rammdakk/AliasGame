//
//  NetworkError.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 25.05.2023.
//

enum NetworkError: Error {
    case noData // No data received
    case decodingFailed // Failed to decode response data
    case invalidRequest(String) // Invalid request with associated error message
    case networkError(String) // Network error with associated error message
    case invalidResponse(String) // Invalid response with associated status code
    
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
