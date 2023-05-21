//
//  TeamModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 21.05.2023.
//

struct TeamModel: Codable {
    let id: String
    let name: String
    let users: [TeamUser]
}

struct TeamUser: Codable {
    let id: String
    let name: String
}
