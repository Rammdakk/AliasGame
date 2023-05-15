//
//  RoomsScreen.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 14.05.2023.
//

import SwiftUI


struct RoomModel: Codable {
    var name: String
}

struct RoomsScreen: View {
    @Binding var navigationState: NavigationState
    let roomsMock = [RoomModel(name: "first"),
                 RoomModel(name: "second"),
                 RoomModel(name: "third"),
                 RoomModel(name: "very long room name for absolutely no reason aaaaa aaaaaaaaa fjfjfjfjf sjfsuu sjsjsjs djdjdjd iwiiw djdjdj"),
                 RoomModel(name: "thirkxkd"),
                 RoomModel(name: "sksksks"),
                 RoomModel(name: "sskksks=="),
                 RoomModel(name: "q9wei"),
                 RoomModel(name: "ividi"),
    ]
    
    var body: some View {
        List{
            ForEach(roomsMock, id: \.name) { item in
                room(model: item)
                    //.padding(.vertical, -15)
            }
        }.listStyle(.plain)
        .background(Color.red.ignoresSafeArea())
        
    }
    
    func room(model: RoomModel) -> some View {
        return ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 150)
                .cornerRadius(20)
                //.overlay(
                //    RoundedRectangle(cornerRadius: 20)
                //        .stroke(Color.black, lineWidth: 5)
                //)
            HStack {
                VStack(alignment: .leading){
                    Text(model.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                }
                .padding(.leading,20)
                Spacer()
                Text("Join")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.red)
                    .cornerRadius(20)
                    .padding(.trailing,20)
                    
                    
                
            }//.frame(height: 150).fixedSize()
        }
        .listRowBackground(Color.red)
        .listRowSeparator(.hidden)
    }
    
}

struct RoomsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RoomsScreen(navigationState: .constant(.Rooms))
    }
}
