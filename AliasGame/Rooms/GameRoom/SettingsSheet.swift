//
//  SettingsSheet.swift
//  AliasGame
//
//  Created by Marina Roshchupkina on 18.05.2023.
//

import SwiftUI

struct SettingsSheet: View {
    @Binding var show: Bool
    @Binding var name: String
    @State private var code: String = ""
    @State private var isPrivate = false
    @State private var pointsPerWord: Double = 10
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            VStack{
                VStack(spacing: 20) {
                    VStack(alignment: .leading){
                        Text("Change game name")
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
                    
                    if isPrivate{
                        VStack(alignment: .leading){
                            Text("Enter access code ")
                                .font(.system(size: 25, weight: .bold))
                            TextField("Code", text: $code)
                            
                        }.padding()
                            .background(.white)
                            .cornerRadius(10)
                    }
                    
                    
                    VStack(alignment: .leading){
                        Text("Points per word: \(Int(pointsPerWord))")
                            .font(.system(size: 25, weight: .bold))
                        Slider(value: $pointsPerWord, in: 1...20).tint(.red)
                    }.padding()
                        .background(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 10)
                .padding(.top, 40)
                
                Spacer()
                button(text: "Done", action: {show.toggle()})
                    .padding(.bottom,20)
            }
        }
    }
    
    private func button(text: String, action: @escaping () -> Void) -> some View {
        return Button(action: action){
            HStack(alignment: .center, spacing: 10) {
                Text(text)
                    .font(.system(size: 25, weight: .bold))
                
            }.frame(width: 150,height: 50)
                .background(.white)
                .cornerRadius(20)
                .foregroundColor(.black)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet(show: .constant(true), name: .constant("Room"))
    }
}
