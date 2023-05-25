//
//  MainScreen.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 13.05.2023.
//

import SwiftUI

struct MainScreen: View {
    
    @StateObject private var viewModel = MainScreenViewModel()
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    @State private var name: String = "Ratata"
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            buttons
        }.onReceive(viewModel.$errorState) { newState in
            if case .Succes(_) = errorState {
                if case .None = newState {
                    return
                }
            }
            withAnimation{
                errorState = newState
            }
        }.onReceive(viewModel.$isSuccesLogout) { isSuccess in
            withAnimation{
                if (isSuccess) {
                    navigationState = .Auth
                }
            }
        }.onReceive(viewModel.$isInRoom) { roomModel in
            withAnimation{
                if (roomModel != nil) {
                    navigationState = .GameRoom(room: roomModel!)
                }
            }
        }
    }
    
    var buttons: some View {
        VStack(spacing: 10) {
            Text("Hi, \(name)!")
                .font(.system(size: 25, weight: .bold)).padding(.top, 30).foregroundColor(.white).onTapGesture {
                    viewModel.profile()
                }.onReceive(viewModel.$name) { newName in
                    print(newName)
                    name = newName
                }.onAppear{
                    viewModel.profile()
                }
            Spacer()
            button(text: "Create room", action: {navigationState = .RoomCreation})
            button(text: "Join room", action: {navigationState = .Rooms})
            Spacer().overlay {
                Button(action: viewModel.logout) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                }
            }

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

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(navigationState: .constant(.Main), errorState: .constant(.Succes(message: "Test")))
    }
}
