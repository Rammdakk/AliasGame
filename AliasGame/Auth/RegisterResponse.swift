//
//  RegisterResponse.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

struct RegisterResponse: Codable {
    let email: String
    let id: String
    let name: String
    let passwordHash: String
}
