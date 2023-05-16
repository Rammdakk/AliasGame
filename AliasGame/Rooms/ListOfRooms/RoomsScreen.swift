//
//  RoomsScreen.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 14.05.2023.
//

import SwiftUI

struct RoomsScreen: View {

    @StateObject private var viewModel = RoomsScreenViewModel()
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState

    
    var body: some View {
        List{
            ForEach(viewModel.listOfRooms, id: \.id) { item in
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
            HStack {
                VStack(alignment: .leading){
                    Text(model.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    if (model.invitationCode != nil)
                    {
                        Text(model.invitationCode!)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                }
                .padding(.leading,20)
                Spacer()
                Text("Join")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.red)
                    .cornerRadius(10)
                    .padding(.trailing,20)
                    
                    
                
            }//.frame(height: 150).fixedSize()
        }
        .listRowBackground(Color.red)
        .listRowSeparator(.hidden)
    }
    
}

struct RoomsScreen_Previews: PreviewProvider {
    static var previews: some View {
        RoomsScreen(navigationState: .constant(.Rooms), errorState: .constant(.None))
    }
}
