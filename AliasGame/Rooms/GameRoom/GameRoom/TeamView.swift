//  TeamView.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 25.05.2023.
//

import SwiftUI

struct Team: View {
    // Represents a view for displaying a team
    
    let model: TeamModel
    let joinAction: () -> Void
    @State var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Chevron icon for expanding/collapsing the team
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
                
                // Team name
                Text(model.name)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Join button
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
                    // Displayed when there are no users in the team
                    Text("No users")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.gray)
                } else {
                    // Display each user in the team
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
