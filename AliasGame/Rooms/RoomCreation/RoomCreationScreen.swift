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
    @State private var numberOfTeams: Int = 2
    @State private var teams = ["team", "team2"]//[String]()
    @State private var showingAlert = false
    @State private var teamName: String = ""
    
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
                    
                    HStack {
                        Text("Teams: \(teams.count)")
                            .font(.system(size: 25, weight: .bold)).padding()
                        Spacer()
                        Button(action: {showingAlert.toggle()} ) {
                            Text("+")
                                .font(.system(size: 25, weight: .bold))
                                .padding(.horizontal)
                                .padding(.vertical,10)
                                .background(.red)
                                .cornerRadius(30)
                                .foregroundColor(.white)
                            
                        }.padding()
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    
                    List {
                        ForEach($teams, id: \.self) { item in
                            team(model: item.wrappedValue)
                        }.onDelete(perform: removeTeam)
                    }
                    .listStyle(.plain)
                    .background(Color.red.ignoresSafeArea())
                    .padding(.horizontal, -8)
                    
                    
                    Spacer()
                    button(text: "Done", action: {viewModel.createRoom(name: name, isPrivate: isPrivate)}, width: 150)
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
            
        }
        .alert("New team", isPresented: $showingAlert) {
            TextField("Enter team name", text: $teamName)
            Button("Create", action: addNewTeam)
            Button("Cancel", role: .cancel, action: {})
        }
        .onReceive(viewModel.$errorState) { newState in
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
    
    func addNewTeam(){
        teams.append(teamName)
        teamName = ""
    }
    
    func removeTeam(at offsets: IndexSet) {
        teams.remove(atOffsets: offsets)
    }
    
    func team(model: String) -> some View {
        return ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 50)
                .cornerRadius(10)
            VStack {
                    Text(model)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
            }
            .padding(.leading,20)
        }
        .listRowBackground(Color.red)
        .listRowSeparator(.hidden)
    }
    
    private func button(text: String, action: @escaping () -> Void, width: CGFloat) -> some View {
        return Button(action: action){
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                    .font(.system(size: 25, weight: .bold))
                
            }.frame(width: width,height: 50)
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
