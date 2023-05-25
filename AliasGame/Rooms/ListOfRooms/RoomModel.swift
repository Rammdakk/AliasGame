//
//  RoomModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import Foundation

struct RoomModel: Codable {
    // Properties of the RoomModel struct
      let isPrivate: Bool
      let id: String
      let admin: String
      let name: String
      let points: Int?
      let creator: String
      let invitationCode: String?
    
    // CodingKeys enum to map the JSON keys to struct properties during decoding
    private enum CodingKeys: String, CodingKey {
        case isPrivate = "isPrivate"
        case id = "id"
        case admin = "admin"
        case name = "name"
        case points = "points"
        case creator = "creator"
        case invitationCode = "invitationCode"
    }
    
    // Initializer for decoding the RoomModel struct from JSON
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // Decode the properties using the appropriate key from the CodingKeys enum
        invitationCode = try values.decodeIfPresent(String.self, forKey: .invitationCode)
        isPrivate = try values.decode(Bool.self, forKey: .isPrivate)
        id = try values.decode(String.self, forKey: .id)
        admin = try values.decode(String.self, forKey: .admin)
        name = try values.decode(String.self, forKey: .name)
        points = try values.decodeIfPresent(Int.self, forKey: .points)
        creator = try values.decode(String.self, forKey: .creator)
    }
    
    // Custom initializer for creating a RoomModel instance
    init(isPrivate: Bool, id: String, admin: String, name: String, creator: String, invitationCode: String?, points: Int?) {
        self.isPrivate = isPrivate
        self.id = id
        self.admin = admin
        self.name = name
        self.creator = creator
        self.invitationCode = invitationCode
        self.points = points
    }
}
