//
//  AppIconView.swift
//  MentalAdditions
//
//  Created by Chaher Machhour on 03/11/2024.
//

import SwiftUI

struct AppIconView: View {
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple]), center: .center, startRadius: 0, endRadius: 500)
                .ignoresSafeArea()
            Text("99")
                .font(.system(size: 200))
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.orange, Color.yellow, Color.orange]),
                    startPoint: .bottomLeading,
                    endPoint: .topTrailing
                ))
        }
    }
}

#Preview {
    AppIconView()
}
