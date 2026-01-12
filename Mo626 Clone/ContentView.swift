//
//  ContentView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 23/12/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                NavigationStack {
                    HomeView()
                }
            }

            Tab("Cards", systemImage: "creditcard") {
                NavigationStack {
                    CardsView()
                }
            }

            Tab("Account", systemImage: "person.crop.circle") {
                NavigationStack {
                    AccountsView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
