//
//  TabBarView.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: TabBar = .main

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabBar.allCases, id: \.self) { tab in
                tab.view
                    .tabItem {
                        Image(systemName: tab.icon)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
    }
}

struct TabBarView_Preview: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
