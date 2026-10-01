//
//  WolfStyleView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import SwiftData
import SwiftUI

struct WolfStyleView: View {
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
    ]

    @Query private var wolves: [Wolf]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Wolf.ColorChoice.allCases.filter { !$0.isPremium }) {
                    choice in
                    Button {
                        if let wolf = wolves.first {
                            wolf.setChoice(choice, isUserPremium: false)
                        }
                    } label: {
                        WolfSelectorComponent(
                            choice: choice,
                            isSelected: wolves.first?.colorChoice == choice
                        )
                        .background(.clear)
                    }
                    .background(Material.regular)
                    .cornerRadius(20)
                    .background(.clear)
                }
            }
            .padding(.top, 50)
        }

        .navigationTitle("Wolf Style")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    WolfStyleView()
}
