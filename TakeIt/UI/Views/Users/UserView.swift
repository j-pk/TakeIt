//
//  UserView.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI

struct UserView: View {
    var user: User
    @State var isExpanded: Bool = false
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            UserPostsView(user: user)
            .onTapGesture { isExpanded.toggle() }
        } label: {
            UserDetailView(user: user)
        }
    }
}

struct UserView_Previews: PreviewProvider { 
    static var previews: some View {
        UserView(user: User.sampleUser)
            .previewLayout(.fixed(width: 400, height: 100))
    }
}

 
