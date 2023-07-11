//
//  UserPostView.swift
//  TakeIt
//
//  Created by Parker on 7/11/23.
//

import SwiftUI

struct UserPostView: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(post.title)")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("\(post.title)")
                .foregroundColor(Color.yellow)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .padding(EdgeInsets(top: -6, leading: 2, bottom: 0, trailing: 2))
            Text("\(post.body)")
                .font(.caption)
                .accessibilityLabel("\(post.body)")
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            UserCommentsView(post: post)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.white)
        .background(Color.purple)
        .cornerRadius(8)
    }
}

struct UserPostView_Previews: PreviewProvider {
    static var previews: some View {
        UserPostView(post: Post.samplePost)
    }
}

