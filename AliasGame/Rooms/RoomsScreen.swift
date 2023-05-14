//
//  RoomsScreen.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 14.05.2023.
//

import SwiftUI

struct RoomsScreen: View {
    @Binding var navigationState: NavigationState
    
    var body: some View {
        Text("Rooms")
    }
}

struct RoomsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RoomsScreen(navigationState: .constant(.Rooms))
    }
}
