//
//  ContentView.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var navigationState: NavigationState = .Auth
    @State private var errorState: ErrorState = .None
    
    var body: some View {
        VStack {
            
            switch navigationState {
                
            case .Auth:
                AuthScreen(navigationState: $navigationState, errorState: $errorState)
                
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
        }.overlay (
            ErrorView(errorState: $errorState)
        )
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
