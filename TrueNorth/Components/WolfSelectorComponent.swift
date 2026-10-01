//
//  WolfSelectorComponent.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import SwiftUI

struct WolfSelectorComponent: View {
    let choice: Wolf.ColorChoice
    let isSelected: Bool

    var body: some View {
        VStack {
            WolfPickerSingleFrameView(
                row: 0,
                column: 0,
                color: choice.swiftName
            )
            .padding(.bottom, 70)
            .frame(maxWidth: 70, maxHeight: 70)
            .background(.clear)
            Text(choice.displayName)
                .padding(4)
                .foregroundStyle(Color.primary)
        }
        .frame(width: 140, height: 140)
        .padding(5)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .glassEffect(
                        .regular.tint(.northBackground.opacity(0.75)),
                        in: .rect(cornerRadius: 20)
                    )
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.clear)
                    .backgroundStyle(.thinMaterial)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    HStack {
        WolfSelectorComponent(choice: .grey, isSelected: true)
        WolfSelectorComponent(choice: .aqua, isSelected: false)
    }
}
