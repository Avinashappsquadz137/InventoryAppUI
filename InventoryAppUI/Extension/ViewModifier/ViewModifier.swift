//
//  ViewModifier.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 10/01/25.
//

import SwiftUI

struct ViewModifiers: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                setNavigationBarAppearance()
            }
    }
    
    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
