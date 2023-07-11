//
//  UsersView.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI
import RealmSwift

struct UsersView: View {
    @ObservedResults(User.self) var fetchedUsers
   
    // Allows for multiple columns
    private var gridItemLayout = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            // More performant than List which renders views immediately
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 10) {
                ForEach(fetchedUsers, id: \.self) { user in
                    UserView(user: user)
                }
            }
            
        }
        .padding()
        .navigationBarTitle(Text("⚯͛ Parker's Rethink Interview"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.yellow, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            Button("Count") {
                print("This displays count values for Realm objects")
            }
        }
    }
}
 
