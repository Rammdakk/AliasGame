//
//  ErrorView.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 14.05.2023.
//

import SwiftUI

struct ErrorView: View {
    
    @Binding var errorState: ErrorState
    
    var body: some View {
        VStack {
            switch errorState {
            case .Succes(let message):
                Text(message)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(.green)
                    .cornerRadius(15)
                    .padding(.horizontal, 10).animation(.spring(dampingFraction: 0.5), value: 1)
            case .Error(let message):
                Text(message)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(.red)
                    .cornerRadius(15)
                    .padding(.horizontal, 10).animation(.spring(dampingFraction: 0.5), value: 1)
            case .None:
                EmptyView()
            }
            Spacer()
        } .padding(.vertical, 15)
            .padding(.horizontal, 5)
    }
}



