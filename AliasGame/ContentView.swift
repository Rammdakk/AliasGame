//
//  ContentView.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var navigationState: NavigationState = .Auth
    
    var body: some View {
        ZStack {
            
            switch navigationState {
                
            case .Auth:
                AuthScreen(navigationState: $navigationState)
                
            case .Main:
                MainScreen(navigationState: $navigationState)
                
            case .RoomCreation:
                RoomCreationScreen(navigationState: $navigationState)
                
            case .Rooms:
                RoomsScreen(navigationState: $navigationState)
//
//            case .Game:
//                GameScreen(navigationState: $navigationState)

            }
        }
    }
}

enum NavigationState: Hashable {
    
    case Auth

    case Main
    
    case RoomCreation
    
    case Rooms
//
//    case GameScreen
}
