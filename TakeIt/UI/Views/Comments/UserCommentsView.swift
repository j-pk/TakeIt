//
//  UserCommentsView.swift
//  TakeIt
//
//  Created by Parker on 7/11/23.
//

import SwiftUI

struct UserCommentsView: View {
    
    var post: Post
    var gridItemLayout = [GridItem(.flexible())]
    @State var isExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ScrollView {
                LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 8) {
                    ForEach(post.comments, id: \.self) { comment in
                        UserCommentView(comment: comment)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(2)
            }
            .onTapGesture { isExpanded.toggle() }
        } label: {
            UserCommentDetails(post: post)
        }
    }
    
}

struct UserCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        UserCommentsView(post: Post.samplePost)
    }
}

 
