//
//  MainView.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI
import RealmSwift

struct MainView: View {
    
    var viewModel: UserViewModel = .init(network: Network.init(), database: Database.init())
 
    var body: some View {
        NavigationView {
            UsersView()
            .task {
                try? await viewModel.populateUsers()
            }
        }
        .accentColor(.purple)
    }
} 

struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

