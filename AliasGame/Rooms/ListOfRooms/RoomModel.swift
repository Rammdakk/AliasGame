//
//  RoomModel.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 16.05.2023.
//

import Foundation

struct RoomModel: Codable {
      let isPrivate: Bool
      let id: String
      let admin: String
      let name: String
      let creator: String
      let invitationCode: String?
    
    private enum CodingKeys: String, CodingKey {
        case isPrivate = "isPrivate"
        case id = "id"
        case admin = "admin"
        case name = "name"
        case creator = "creator"
        case invitationCode = "invitationCode"
    }
    
    init(from decoder: Decoder) throws {
          let values = try decoder.container(keyedBy: CodingKeys.self)
          invitationCode = try values.decodeIfPresent(String.self, forKey: .invitationCode) ?? nil
        isPrivate = try values.decode(Bool.self, forKey: .isPrivate)
        id = try values.decode(String.self, forKey: .id)
        admin = try values.decode(String.self, forKey: .admin)
        name = try values.decode(String.self, forKey: .name)
        creator = try values.decode(String.self, forKey: .creator)
      }
}
