//
//  UserPostsView.swift
//  TakeIt
//
//  Created by Parker on 7/11/23.
//

import SwiftUI

struct UserPostsView: View {
    var user: User
    // Allows for multiple columns
    var gridItemLayout = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 8) {
                ForEach(user.posts, id: \.self) { post in
                    UserPostView(post: post)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(4)
        }
    }
}

struct UserPostsView_Previews: PreviewProvider {
    static var previews: some View {
        UserPostsView(user: User.sampleUser)
    }
}



