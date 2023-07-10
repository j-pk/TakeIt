//
//  MainView.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            Text("MainView Screen")
                .navigationBarTitle(Text("⚯͛ Parker's Rethink Interview"))
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.yellow.opacity(0.5), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    Button("Count") {
                        print("This displays count values for Realm objects")
                    }
                }
        }
        
    }
}


struct MainView_Preview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

