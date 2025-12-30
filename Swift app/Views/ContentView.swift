import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var authState: AuthState
    
    var body: some View{
        NavigationStack {
            if authState.isLoggedIn {
                BottomTabView()
            } else {
                LoginView()
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AuthState())
}
