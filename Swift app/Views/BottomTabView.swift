//
//  BottomTabView.swift
//  Swift app
//
//  Created by Ankit on 12/30/25.
//
import SwiftUI

struct BottomTabView : View {
    var body : some View {
        TabView {
            Tab("Home", systemImage: "house"){
                HomeView()
            }
            Tab("Profile", systemImage: "person.crop.circle.fill"){
                ProfileView()
            }
        }
    }
    
}
