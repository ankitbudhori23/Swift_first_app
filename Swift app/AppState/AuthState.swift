import Foundation
import SwiftUI

final class AuthState: ObservableObject {
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    @Published var currentUser: User? {
      didSet {
            if let user = currentUser {
                let data = try? JSONEncoder().encode(user)
                UserDefaults.standard.set(data, forKey: "currentUser")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
        }
    }

    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if let data = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            self.currentUser = user
        } else {
            self.currentUser = nil
        }
    }

    func logout() {
        isLoggedIn = false
        currentUser = nil
    }
}
