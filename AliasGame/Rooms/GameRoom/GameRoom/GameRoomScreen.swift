//
//  GameRoom.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 18.05.2023.
//


// TODO:
// Добавить кнопку возврата назад - возврат сразу в главное меню надо делать и делать его с выходом из игры.
// Связать с экранами создания и джойна комнаты - Done. Только при изменении настроек у других пользователей они не обновятся в плане UI(.
// Сделать вариант UI для игроков (убрать кнопку настройки например) - можно не убирать, запрос на изменение не пройдет.




import SwiftUI

struct GameRoomScreen: View {
    
    @StateObject private var viewModel: GameRoomScreenViewModel

    init(navigationState: Binding<NavigationState>, errorState: Binding<ErrorState>, room: RoomModel) {
        _viewModel = StateObject(wrappedValue: GameRoomScreenViewModel(navigationState: navigationState.wrappedValue))
        self._navigationState = navigationState
        self._errorState = errorState
        self.room = room
    }
    
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
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            mainView
                .sheet(isPresented: $showSettings) {
                        SettingsSheet(show: $showSettings.animation(), room: $currentRoom, errorState: $errorState)
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
                }.onReceive(viewModel.$teams){ teams in
                        teamMocks = teams
                }
        }
    
    
    var mainView: some View {
        VStack {
            header
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).padding()
                ).onAppear{
                    currentRoom = room
                }
            List{
                ForEach(teamMocks, id: \.id) { item in
                    Team(model: item) {
                        viewModel.joinTeam(teamID: item.id, roomID: room.id)
                    }
                    
                }.onDelete(perform: delete)
            }
            .listStyle(.plain)
            .background(Color.red.ignoresSafeArea()).onAppear{
                viewModel.loadTeams(roomID: room.id)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        teamMocks.remove(atOffsets: offsets)
    }
    
    var header: some View {
        VStack(alignment: .leading){
                HStack {
                    Text("Room name: \(currentRoom.name)" )
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.black).padding(.horizontal)
                    Spacer()
                    VStack {
                        Button(action: {showSettings.toggle()}){
                            Image(systemName: "gearshape.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        Button(action: {viewModel.leaveRoom(roomID: room.id)}){
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title)
                                .foregroundColor(.black)
                        }.padding()
                    }
                    
                }.padding()
                
                VStack(alignment:.leading, spacing: 5){
                    Text("ID: \(currentRoom.id)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                  // В текущей реализации бэка код будет приходить всегда, даже если комната public
                    Text("Code: \(currentRoom.invitationCode ?? "Room is public")")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    
                }
                .padding()
                .textSelection(.enabled)
        }.padding(.vertical)
    }
    
    struct Team: View {
        
        let model: TeamModel
        let joinAction: () -> Void
        @State var isExpanded = false
        
        var body: some View {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .onTapGesture {
                            isExpanded.toggle()
                        }
                    Text(model.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Text("Join")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .onTapGesture {
                            joinAction()
                        }
                        .padding(10)
                        .background(.green)
                        .cornerRadius(10)
                }
                
                if isExpanded {
                    if model.users.isEmpty {
                        Text("No users")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(model.users, id: \.self) { teamUser in
                            Text(teamUser.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(10)
            )
            .listRowBackground(Color.red)
            .listRowSeparator(.hidden)
        }
    }
}

//struct GameRoomScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        GameRoomScreen(navigationState: .constant(.GameRoom(room: RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10))), errorState: .constant(.None),  room: (RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10)))
//    }
//}
