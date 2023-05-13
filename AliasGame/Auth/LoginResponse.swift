//
//  LoginResponse.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

struct LoginResponse: Codable {
    let value: String
    let id: String
    let user: User
}

struct User: Codable {
    let id: String
}
