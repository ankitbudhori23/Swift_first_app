import SwiftUI
import UIKit

struct NumberDetail: View { let n: Int; var body: some View { Text("Number: \(n)") } }

struct ContentView: View {
    @EnvironmentObject var authState: AuthState
    
    var body: some View{
        NavigationStack {
            if authState.isLoggedIn {
               HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
          print("currentUser:", authState.currentUser as Any)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AuthState())
}
