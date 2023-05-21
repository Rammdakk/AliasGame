//
//  SettingsSheet.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 18.05.2023.
//

import SwiftUI

struct SettingsSheet: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @Binding var show: Bool
    @Binding var room: RoomModel
    @Binding var errorState: ErrorState
    
    @State private var name: String = ""
    @State private var isPrivate = false
    @State private var pointsPerWord: Double = 10
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack{
                VStack(spacing: 20) {
                    VStack(alignment: .leading){
                        Text("Change game name")
                            .font(.system(size: 25, weight: .bold))
                        TextField("Name", text: $name).onAppear(perform: {name = room.name})
                        
                    }.padding()
                        .background(.white)
                        .cornerRadius(10)
                    
                    Toggle("Make room private", isOn: $isPrivate.animation())
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                        .font(.system(size: 25, weight: .bold))
                        .padding()
                        .background(.white)
                        .cornerRadius(10).onAppear(perform: {isPrivate = room.isPrivate})
                    
                    VStack(alignment: .leading){
                        Text("Points per word: \(Int(pointsPerWord))")
                            .font(.system(size: 25, weight: .bold)).onAppear(perform: {pointsPerWord = Double(room.points ?? 10)})
                        Slider(value: $pointsPerWord, in: 1...20).tint(.red)
                    }.padding()
                        .background(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 10)
                .padding(.top, 40)
                
                Spacer()
                button(text: "Done", action: {viewModel.createRoom(roomID: room.id, newName: name, isPrivate: isPrivate, points: Int(pointsPerWord))})
                    .padding(.bottom,20)
            }
        }.onReceive(viewModel.$errorState) { newState in
            if case .Succes(_) = errorState {
                if case .None = newState {
                    return
                }
            }
            withAnimation{
                if case .Error(_) = newState {
                    errorState = .None
                    errorState = newState
                    show = false
                    return
                }
                errorState = newState
            }
        }.onReceive(viewModel.$newRoom){newRoom in
            if (newRoom != nil) {
                room = newRoom!
                show = false
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

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet(show: .constant(true), room: .constant(RoomModel(isPrivate: false, id: "81F61C99-9178-4BE9-85E5-343381619FB9", admin: "User1", name: "Room1-public", creator: "User1", invitationCode: "aSwTb", points: 10)), errorState: .constant(.None))
    }
}
