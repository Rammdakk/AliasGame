//
//  ErrorState.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 14.05.2023.
//

enum ErrorState {
    
    case Error(message: String) // Represents an error state with an associated error message
    
    case Succes(message: String) // Represents a success state with an associated success message
    
    case None // Represents no error state
}
