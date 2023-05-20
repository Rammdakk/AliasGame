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
    
    enum CodingKeys: String, CodingKey {
        case isPrivate = "isPrivate"
        case admin = "admin"
        case creator = "creator"
        case pointsPerWord = "pointsPerWord"
        case name = "name"
        case invitationCode = "invitationCode"
        case id = "id"
    }
    
    struct Admin: Codable {
        let id: String
    }
    
    struct Creator: Codable {
        let id: String
    }
    
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
    
    init(isPrivate: Bool, admin: Admin, creator: Creator, pointsPerWord: Int, name: String, invitationCode: String, id: String) {
        self.isPrivate = isPrivate
        self.admin = admin
        self.creator = creator
        self.pointsPerWord = pointsPerWord
        self.name = name
        self.invitationCode = invitationCode
        self.id = id
    }
    
    func mapToRoomModel() -> RoomModel {
        return RoomModel(isPrivate: isPrivate, id: id, admin: admin.id, name: name, creator: creator.id, invitationCode: invitationCode, points: pointsPerWord)
    }
}
