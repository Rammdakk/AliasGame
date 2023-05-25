//  TeamModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 21.05.2023.
//

struct TeamModel: Codable {
    // Represents a team in the game room
    
    let id: String
    let name: String
    let users: [TeamUser]
}

struct TeamUser: Codable, Hashable {
    // Represents a user in a team
    
    let id: String
    let name: String
}
