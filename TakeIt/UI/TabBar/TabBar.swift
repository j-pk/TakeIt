//
//  TabBar.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI

enum TabBar: String, CaseIterable, Codable {
    case main, search
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .main: MainView()
        case .search: SearchView()
        }
    }
    
    var icon: String {
        switch self {
        case .main: return "figure.wave"
        case .search: return "magnifyingglass"
        }
    }
}
