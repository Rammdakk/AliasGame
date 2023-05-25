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
    @State private var showingAlert = false
    @State private var code = ""
    @State private var id = ""
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.listOfRooms, id: \.id) { item in
                    room(model: item)
                }
            }
            .listStyle(.plain)
            .background(Color.red.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { navigationState = .Main }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAlert.toggle() }) {
                        Image(systemName: "lock.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(.red, for: .navigationBar)
        }
        .alert("Entering private room", isPresented: $showingAlert) {
            TextField("Enter id", text: $id)
            TextField("Enter code", text: $code)
            Button("Enter", action: { viewModel.joinRoom(roomID: id, invitationCode: code) })
            Button("Cancel", role: .cancel, action: {})
        }
        .onReceive(viewModel.$errorState) { newState in
            if case .Succes(_) = errorState {
                if case .None = newState {
                    return
                }
            }
            withAnimation {
                errorState = newState
            }
        }
        .onReceive(viewModel.$navigationState) { newState in
            withAnimation {
                navigationState = newState
            }
        }
    }
    
    // Room view for displaying a single room
    func room(model: RoomModel) -> some View {
        return ZStack {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 150)
                .cornerRadius(10)
            HStack {
                VStack(alignment: .leading) {
                    Text(model.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.leading, 20)
                Spacer()
                Button(action: {
                    viewModel.joinRoom(roomID: model.id, invitationCode: nil)
                }) {
                    Text("Join")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(10)
                        .background(.green)
                        .cornerRadius(10)
                        .padding(.trailing, 20)
                }
            }
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
