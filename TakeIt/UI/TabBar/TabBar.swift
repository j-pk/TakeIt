//
//  TabBar.swift
//  TakeIt
//
//  Created by Parker on 7/10/23.
//

import SwiftUI

enum TabBar: String, CaseIterable, Codable {
    case main
    
    var title: String {
        return self.rawValue.capitalized
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .main: MainView()
        }
    }
    
    var icon: String {
        switch self {
        case .main: return "figure.wave"
        }
    }
}
