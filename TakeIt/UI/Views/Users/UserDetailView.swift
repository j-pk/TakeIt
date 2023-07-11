//
//  UserDetailView.swift
//  TakeIt
//
//  Created by Parker on 7/11/23.
//

import SwiftUI

struct UserDetailView: View {
    var user: User

    var body: some View {
        HStack() {
            Text(user.name)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
                .accessibilityLabel(user.name)
            Spacer()
            Label("\(user.posts.count)", systemImage: "newspaper.fill")
                .accessibilityLabel("\(user.posts.count) posts")
                .font(.caption)
        }
        .padding()
        .foregroundColor(Color.yellow)
        .background(Color.purple)
        .cornerRadius(8)
    }
}


struct UserCardView_Previews: PreviewProvider {
 
    static var previews: some View {
        UserDetailView(user: User.sampleUser)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}

