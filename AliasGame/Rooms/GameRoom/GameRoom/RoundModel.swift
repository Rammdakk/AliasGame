//
//  RoundModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 25.05.2023.
//

import Foundation

// MARK: - RoundInfo
struct RoundInfo: Codable {
    let startTime: String
    let id: String
    let gameRoom: Room
    let endTime: String?
    let state: String
}

// MARK: - GameRoom
struct Room: Codable {
    let id: String
}
