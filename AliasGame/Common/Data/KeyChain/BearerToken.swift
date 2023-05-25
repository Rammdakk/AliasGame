//
//  BearerToken.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 14.05.2023.
//

import Foundation

// Keys for keyChain to save bearer token.
let account = "com.rammdakk.AliasGame"
let userBearerTokenService = "userBearerToken"

 struct BearerToken: Codable {
     let bearerToken: String
 }
