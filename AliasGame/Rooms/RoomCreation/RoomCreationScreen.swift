//
//  RoomCreationScreen.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 14.05.2023.
//

import SwiftUI

struct RoomCreationScreen: View {
    
    @StateObject private var viewModel = RoomCreationViewModel()
    
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    
    @State private var name: String = ""
    @State private var isPrivate = false
    @State private var code: String = ""
    @State private var numberOfRoudns: Double = 1
    @State private var numberOfTeams: Double = 2
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.red.ignoresSafeArea()
                VStack{
                    VStack(spacing: 20) {
                        VStack(alignment: .leading){
                            Text("Enter game name")
                                .font(.system(size: 25, weight: .bold))
                            TextField("Name", text: $name)
                            
                        }.padding()
                            .background(.white)
                            .cornerRadius(10)
                        
                        Toggle("Make room private", isOn: $isPrivate.animation())
                            .toggleStyle(SwitchToggleStyle(tint: .red))
                            .font(.system(size: 25, weight: .bold))
                            .padding()
                            .background(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 40)
                    
                    Spacer()
                    button(text: "Done", action: {viewModel.createRoom(name: name, isPrivate: isPrivate)})
                        .padding(.bottom,20)
                }
                
            }.toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {navigationState = .Main}) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
            }
            
        }.onReceive(viewModel.$errorState) { newState in
            if case .Succes(_) = errorState {
                if case .None = newState {
                    return
                }
            }
            withAnimation{
                errorState = newState
            }
        }.onReceive(viewModel.$navigationState){ newState in
            withAnimation{
                navigationState = newState
            }
        }
    }
    
    private func button(text: String, action: @escaping () -> Void) -> some View {
        return Button(action: action){
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                    .font(.system(size: 25, weight: .bold))
                
            }.frame(width: 150,height: 50)
                .background(.white)
                .cornerRadius(20)
                .foregroundColor(.black)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
}




struct RoomCreationScreen_Previews: PreviewProvider {
    static var previews: some View {
        RoomCreationScreen(navigationState: .constant(.RoomCreation), errorState: .constant(.None))
    }
}
