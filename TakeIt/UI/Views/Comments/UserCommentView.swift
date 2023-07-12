//
//  UserCommentView.swift
//  TakeIt
//
//  Created by Parker on 7/11/23.
//

import SwiftUI

struct UserCommentView: View {
    var comment: Comment
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(comment.name)")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel("\(comment.name)")
                .foregroundColor(Color.yellow)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("\(comment.email)")
                .font(.subheadline)
                .accessibilityLabel("\(comment.email)")
                .foregroundColor(Color.yellow)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .padding(EdgeInsets(top: -6, leading: 2, bottom: 0, trailing: 2))
            Text("\(comment.body)")
                .font(.caption)
                .accessibilityLabel("\(comment.body)")
                .frame(maxWidth: .infinity, alignment: .leading)
         }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(Color.black)
        .background(Color.blue)
        .cornerRadius(8)
    }
}

struct UserCommentView_Previews: PreviewProvider {
    static var previews: some View {
        UserCommentView(comment: Comment.sampleComment)
    }
}
