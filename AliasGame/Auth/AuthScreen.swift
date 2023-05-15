import SwiftUI

struct AuthScreen: View {
    @StateObject private var viewModel = AuthViewModel()
    @Binding var navigationState: NavigationState
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            VStack(spacing: 20) {
                if viewModel.showLogin {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        viewModel.login(email: email, password: password)
                    }) {
                        Text("Login")
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 5)
                            )
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
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 5)
                            )
                    }
                }

                if viewModel.showLogin || viewModel.showRegister {
                    Button(action: {
                        viewModel.showLogin = false
                        viewModel.showRegister = false
                    }) {
                        Text("Back")
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .foregroundColor(.red)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {
                        viewModel.showLogin = true
                    }) {
                        Text("Login")
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 200, height: 50)
                            .background(Color.white)
                            .foregroundColor(.red)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        viewModel.showRegister = true
                    }) {
                        Text("Register")
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 5)
                            )
                    }
                }
            }

            .padding().onReceive(viewModel.$isSuccesAuth) {
                isSucces in
                if isSucces == true {
                    print("Auth finished")
                    navigationState = .Main
                }
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

