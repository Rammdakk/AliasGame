//
//  SettingsSheet.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 18.05.2023.
//

import SwiftUI

struct SettingsSheet: View {
    @Binding var show: Bool
    var body: some View {
        VStack {
            Text("This is settings sheet")
            Button(action: {show.toggle()}){
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
            }
        }
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet(show: .constant(true))
    }
}
