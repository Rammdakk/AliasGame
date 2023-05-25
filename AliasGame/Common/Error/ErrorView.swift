//
//  ErrorView.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 14.05.2023.
//

import SwiftUI

struct ErrorView: View {
    
    // Define constants for the show times of success and error notifications
    private let successNotificationShowTime: UInt64 = 1_500_000_000
    private let errorNotificationShowTime: UInt64 = 2_800_000_000
    
    // Binding to the error state
    @Binding var errorState: ErrorState
    
    var body: some View {
        VStack {
            switch errorState {
            case .Succes(let message): // When the error state is Success
                Text(message)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(.green)
                    .cornerRadius(15)
                    .padding(.horizontal, 10).animation(.spring(dampingFraction: 0.5), value: 1)
                    .task(hideNotification)
            case .Error(let message): // When the error state is Error
                Text(message)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(.black)
                    .cornerRadius(15)
                    .padding(.horizontal, 10).animation(.spring(dampingFraction: 0.5), value: 1)
                    .task(hideNotification)
            case .None: // When the error state is None
                EmptyView()
            }
            Spacer()
        } .padding(.vertical, 15)
            .padding(.horizontal, 5)
    }
    
    @Sendable private func hideNotification() async {
        switch errorState {
        case .Error(_): // If the error state is Error, sleep for the specified time
            try? await Task.sleep(nanoseconds: errorNotificationShowTime)
        case .Succes(_): // If the error state is Success, sleep for the specified time
            try? await Task.sleep(nanoseconds: successNotificationShowTime)
        case .None: // If the error state is None, return without sleeping
            return
        }
        errorState = .None // Reset the error state to None after sleeping
    }
}
