//
//  UserCommentDetails.swift
//  TakeIt
//
//  Created by Parker on 7/11/23.
//

import SwiftUI

struct UserCommentDetails: View {
    var post: Post

    var body: some View {
        HStack() {
            Text("Comments")
                .font(.subheadline)
                .accessibilityIdentifier("Comments")
            Spacer()
            Label("\(post.comments.count)", systemImage: "message.fill")
                .accessibilityLabel("\(post.comments.count) comments")
                .font(.caption)
        }
        .padding(8)
        .foregroundColor(Color.black)
        .background(Color.blue)
        .cornerRadius(8)
    }
}


struct UserCommentDetails_Previews: PreviewProvider {
 
    static var previews: some View {
        UserCommentDetails(post: Post.samplePost)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}



