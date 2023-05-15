import SwiftUI

struct AuthScreen: View {
    @StateObject private var viewModel = AuthViewModel()
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if viewModel.showLogin {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    viewModel.login(email: email, password: password)
                }) {
                    Text("Login")
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            if viewModel.showRegister {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    viewModel.register(email: email, password: password, username: username)
                }) {
                    Text("Register")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            if viewModel.showLogin || viewModel.showRegister {
                Button(action: {
                    viewModel.showLogin = false
                    viewModel.showRegister = false
                }) {
                    Text("Back")
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                HStack{
                    Spacer()
                    Button(action: {
                        viewModel.showLogin = true
                    }) {
                        Text("Login")
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                Button(action: {
                    viewModel.showRegister = true
                }) {
                    Text("Register")
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding().overlay(ErrorView(errorState: $errorState))
        .onReceive(viewModel.$isSuccesAuth) {
            isSucces in
            if isSucces == true {
                print("Auth finished")
                navigationState = .Main
            }
        }.onReceive(viewModel.$errorState) { newState in
            withAnimation{
                errorState = newState
            }
        }
    }
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen(navigationState: .constant(.Auth), errorState: .constant(.Succes(message: "gvdeqfv whfbo wihfgi wufihgv")))
    }
}

