import SwiftUI

struct AuthScreen: View {
    @StateObject private var viewModel = AuthViewModel()
    @Binding var navigationState: NavigationState
    @Binding var errorState: ErrorState
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    @State private var isPasswordVisible = false
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            VStack(spacing: 20) {
                if viewModel.showLogin {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        PasswordTextField("Password", text: $password, isSecure: !isPasswordVisible)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                HStack{
                                    Spacer()
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.trailing, 8)
                                }
                            )
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

                    PasswordTextField("Password", text: $password, isSecure: !isPasswordVisible)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            HStack{
                                Spacer()
                                Button(action: {
                                    isPasswordVisible.toggle()
                                }) {
                                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.trailing, 8)
                            }
                        )

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
            if case .Succes(_) = errorState {
                if case .None = newState {
                    return
                }
            }
            withAnimation{
                errorState = newState
            }
        }
    }
}

struct AuthScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthScreen(navigationState: .constant(.Auth), errorState: .constant(.Succes(message: "Test")))
    }
}


struct PasswordTextField: View {
    private var title: String
    @Binding private var text: String
    private var isSecure: Bool
    
    init(_ title: String, text: Binding<String>, isSecure: Bool) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}
