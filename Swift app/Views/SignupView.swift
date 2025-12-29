import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false

    func Submit() {
        if(name.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty) {
            showAlert = true
        } else {
            print("Signing up with name: \(name), email: \(email), username: \(username), and password: \(password)")
        }
    }
    var body: some View{
        VStack(spacing: 20) {
            Text("Signup")
            .font(.largeTitle)

        AppTextField(title: "Name", text: $name)
        AppTextField(title: "Email", text: $email)
        AppTextField(title: "Username", text: $username)
        AppTextField(title: "Password", text: $password, isSecure: true)
        PrimaryButton(title: "Signup") {
            Submit()
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter all fields.")
        }  
        .padding()
    }
}
