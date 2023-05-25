//
//  GameRoom.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 18.05.2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct GameRoomScreen: View {
    
    @StateObject private var viewModel: GameRoomScreenViewModel
    
    // MARK: - Initialization
    
    init(navigationState: Binding<NavigationState>, errorState: Binding<ErrorState>, room: RoomModel) {
        _viewModel = StateObject(wrappedValue: GameRoomScreenViewModel(navigationState: navigationState.wrappedValue, roomAdminID: room.admin))
        self._navigationState = navigationState
        self._errorState = errorState
        self.room = room
    }
    
    // MARK: - State and Binding Properties
    
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    var room: RoomModel
    
    @State private var currentRoom: RoomModel = RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10)
    @State private var showSettings = false
    @State private var teamMocks = [
        TeamModel(
            id: "123",
            name: "F1 team",
            users: [TeamUser(id: "1", name: "User1")]
        ),
        TeamModel(
            id: "456",
            name: "F3 team",
            users: [
                TeamUser(id: "2", name: "User2"),
                TeamUser(id: "3", name: "User3")
            ]
        ),
        TeamModel(
            id: "789",
            name: "F4 team",
            users: []
        )
    ]
    
    // MARK: - Body View
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            mainView
                .sheet(isPresented: $showSettings) {
                    SettingsSheet(show: $showSettings.animation(), room: $currentRoom, errorState: $errorState)
                }
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
        .onReceive(viewModel.$teams) { teams in
            teamMocks = teams
        }
    }
    
    // MARK: - Main View
    
    var mainView: some View {
        VStack {
            header
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).padding()
                )
                .onAppear {
                    currentRoom = room
                }
            List {
                ForEach(teamMocks, id: \.id) { item in
                    Team(model: item) {
                        viewModel.joinTeam(teamID: item.id, roomID: room.id)
                    }
                }
                .onDelete(perform: delete)
            }
            .listStyle(.plain)
            .background(Color.red.ignoresSafeArea())
            .onAppear {
                viewModel.loadTeams(roomID: room.id)
            }
            if (viewModel.isAdmin)
            {
                HStack{
                    Button(action: {viewModel.changeRoundStatus(roomID: room.id, url: UrlLinks.START_ROUND) }) {
                        Spacer()
                       Text("Start round")
                        Spacer()
                    } .padding(10) .background(.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                    
                    Button(action: {viewModel.changeRoundStatus(roomID: room.id, url: UrlLinks.PAUSE_ROUND) }) {
                        Spacer()
                       Text("Pause round")
                        Spacer()
                    } .padding(10).background(.white)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }.padding(20)
            }
        }
    }
    
    // MARK: - Delete Teams
    
    func delete(at offsets: IndexSet) {
        teamMocks.remove(atOffsets: offsets)
    }
    
    // MARK: - Header View
    
    var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Room name: \(currentRoom.name)")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                Spacer()
                VStack {
                    if (viewModel.isAdmin) {
                        Button(action: { showSettings.toggle() }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    Button(action: { viewModel.leaveRoom(roomID: room.id) }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("ID: \(currentRoom.id)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                // In the current backend implementation, the invitation code will always be provided, even if the room is public
                Text("Code: \(currentRoom.invitationCode ?? "Room is public")")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .onTapGesture {
                        let clipboard = UIPasteboard.general
                        clipboard.setValue(currentRoom.invitationCode ?? "", forPasteboardType: UTType.plainText.identifier)
                        errorState = .Succes(message: "Code copied")
                    }
            }
            .padding()
        }
        .padding(.vertical)
    }
}

struct GameRoomScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameRoomScreen(navigationState: .constant(.GameRoom(room: RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10))), errorState: .constant(.None),  room: (RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10)))
    }
}
