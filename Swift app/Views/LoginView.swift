import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @EnvironmentObject var authState: AuthState

    func Submit() {
        if(username.isEmpty || password.isEmpty) {
            showAlert = true
        } else {
            authState.isLoggedIn = true
            authState.currentUser = User(id: UUID().uuidString, username: username, name:"Ankit", email: "\(username)@example.com")
        }
    }
    var body: some View{
        VStack(spacing: 20) {
            Text("Login")
            .font(.largeTitle)

            AppTextField(title: "Username", text: $username)
            AppTextField(title: "Password", text: $password, isSecure: true)
            PrimaryButton(title: "Login") {
                Submit()
                }
            NavigationLink {
                SignupView()
            } label: {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter both username and password.")
        }
        .padding()
    }
}
