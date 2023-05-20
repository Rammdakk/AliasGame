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

struct PlayerModel: Codable {
    var name: String
}

struct GameRoomScreen: View {
    
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    var room: RoomModel
    
    @State private var currentRoom: RoomModel = RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10)
    @State private var showSettings = false
    @State var playersMock = [PlayerModel(name: "Bob"),
                              PlayerModel(name: "not Bob"),
                              PlayerModel(name: "definitely not Bob"),
                              PlayerModel(name: "Amogus"),
                              PlayerModel(name: "Ivan")]
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            mainView
                .sheet(isPresented: $showSettings) {
                        SettingsSheet(show: $showSettings.animation(), room: $currentRoom, errorState: $errorState)
                    }
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
                ForEach(playersMock, id: \.name) { item in
                    player(model: item)
                    
                }.onDelete(perform: delete)
            }
            .listStyle(.plain)
            .background(Color.red.ignoresSafeArea())
        }
    }
    
    func delete(at offsets: IndexSet) {
        playersMock.remove(atOffsets: offsets)
    }
    
    var header: some View {
        VStack(alignment: .leading){
                HStack {
                    Text("Room name: \(currentRoom.name)" )
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.black).padding(.horizontal)
                    Spacer()
                    Button(action: {showSettings.toggle()}){
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
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

func player(model: PlayerModel) -> some View {
    return ZStack(alignment: .leading) {
        Rectangle()
            .foregroundColor(.white)
            .frame(height: 50)
            .cornerRadius(10)
        VStack {
            HStack{
                Text(model.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
                Text("0")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .padding()
            }
            
        }
        .padding(.leading,20)
    }
    .listRowBackground(Color.red)
    .listRowSeparator(.hidden)
}
}

struct GameRoomScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameRoomScreen(navigationState: .constant(.GameRoom(room: RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10))), errorState: .constant(.None),  room: (RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10)))
    }
}
