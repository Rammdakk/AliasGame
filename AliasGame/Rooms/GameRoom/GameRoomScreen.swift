//
//  GameRoom.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 18.05.2023.
//


// TODO:
// Добавить кнопку возврата назад
// Связать с экранами создания и джойна комнаты
// Сделать вариант UI для игроков (убрать кнопку настройки например)




import SwiftUI

struct PlayerModel: Codable {
    var name: String
}

struct GameRoomScreen: View {
    @Binding var navigationState: NavigationState
    @State var name = "Game room"
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
                    SettingsSheet(show: $showSettings.animation(), name: $name)
                }
        }
    }
    
    
    var mainView: some View {
        VStack {
            header
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundColor(.white).padding()
                )
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
            switch navigationState {
            case .GameRoom(let room):
                HStack {
                    Text("Room name: \(room.name)" )
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
                    Text("ID: 09518E1B-4D96-45D1-8E5F-6E756C8A98A4")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    Text("Code: CODE")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal)
                    
                    
                }
                .padding()
                .textSelection(.enabled)
            default:
                Text("Error" )
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(.black).padding(.horizontal)
        }
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
        GameRoomScreen(navigationState: .constant(.GameRoom(room: RoomModel(isPrivate: false, id: "123", admin: "admin1", name: "Room 1", creator: "creator1", invitationCode: "code1", points: 10))))
    }
}