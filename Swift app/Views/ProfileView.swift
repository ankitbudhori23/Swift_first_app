import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authState: AuthState
    
    var body: some View {
        VStack {
            Circle()
                .foregroundStyle(.yellow)
                .frame(width: 200, height: 200)
                .overlay(
                    Text("Name")
                        .bold()
                        .font(.title)
                )
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        print("Profile tapped")
                    } label: {
                        Label("Profile", systemImage: "person")
                    }
                    
                    Button(role: .destructive) {
                        authState.logout()
                    } label: {
                        Label("Logout", systemImage: "arrow.backward.square")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                
            }
        }
    }
}
