//
//  GameRoom.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 18.05.2023.
//

struct GameRoom: Codable {
    let isPrivate: Bool
    let admin: Admin
    let creator: Creator
    let pointsPerWord: Int
    let name: String
    let invitationCode: String
    let id: String
    
    // Coding keys for decoding and encoding
    enum CodingKeys: String, CodingKey {
        case isPrivate = "isPrivate"
        case admin = "admin"
        case creator = "creator"
        case pointsPerWord = "pointsPerWord"
        case name = "name"
        case invitationCode = "invitationCode"
        case id = "id"
    }
    
    // Admin struct representing the admin of the game room
    struct Admin: Codable {
        let id: String
    }
    
    // Creator struct representing the creator of the game room
    struct Creator: Codable {
        let id: String
    }
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        isPrivate = try values.decode(Bool.self, forKey: .isPrivate)
        admin = try values.decode(Admin.self, forKey: .admin)
        creator = try values.decode(Creator.self, forKey: .creator)
        pointsPerWord = try values.decode(Int.self, forKey: .pointsPerWord)
        name = try values.decode(String.self, forKey: .name)
        invitationCode = try values.decode(String.self, forKey: .invitationCode)
        id = try values.decode(String.self, forKey: .id)
    }
    
    // Custom initializer for creating a game room
    init(isPrivate: Bool, admin: Admin, creator: Creator, pointsPerWord: Int, name: String, invitationCode: String, id: String) {
        self.isPrivate = isPrivate
        self.admin = admin
        self.creator = creator
        self.pointsPerWord = pointsPerWord
        self.name = name
        self.invitationCode = invitationCode
        self.id = id
    }
    
    // Function to map the game room to a RoomModel object
    func mapToRoomModel() -> RoomModel {
        return RoomModel(isPrivate: isPrivate, id: id, admin: admin.id, name: name, creator: creator.id, invitationCode: invitationCode, points: pointsPerWord)
    }
}
