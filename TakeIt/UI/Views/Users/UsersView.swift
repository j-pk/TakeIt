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
    @ObservedObject var viewModel: UserViewModel
    @State var displayPopover = false

    // Allows for multiple columns
    var gridItemLayout = [GridItem(.flexible())]
 
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
                self.displayPopover = true
            }
            .sheet(isPresented: $displayPopover) {
                ShadowedText(text: "Users count", count: viewModel.userCount)
                ShadowedText(text: "Posts count", count: viewModel.postCount)
                ShadowedText(text: "Comments count", count: viewModel.commentCount)
            }
        }
    }
}
 
struct ShadowedText: View {
    var text: String
    var count: Int

    var body: some View {
        Text("\(text) \(count)")
            .font(.system(size: 30, weight: .bold))
            .foregroundColor(Color.purple)
            .shadow(color: Color.gray, radius: 2, x: 0, y: 2)
            .accessibilityLabel("\(text) \(count)")
    }
}
