//
//  MainScreen.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

import SwiftUI

struct MainScreen: View {
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            buttons
        }
    }
    
    var buttons: some View {
        VStack(spacing: 10) {
            button(text: "Create room", action: {navigationState = .RoomCreation})
            button(text: "Join room", action: {navigationState = .Rooms})
            
        }
    }
    
    private func button(text: String, action: @escaping () -> Void) -> some View {
        return Button(action: action){
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                    .font(.system(size: 25, weight: .bold))
                
            }.frame(width: 180,height: 80)
                .background(.white)
                .cornerRadius(20)
                .foregroundColor(.black)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    

    
}

public struct ScaleButtonStyle: ButtonStyle {
    
    public init(scaleEffect: CGFloat = 0.90, duration: Double = 0.2) {
        self.scaleEffect = scaleEffect
        self.duration = duration
    }
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .scaleEffect(configuration.isPressed ? scaleEffect : 1)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
    
    private let scaleEffect: CGFloat
    private let duration: Double
}

