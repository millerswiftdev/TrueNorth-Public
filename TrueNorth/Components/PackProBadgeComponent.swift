//
//  PackProBadgeComponent.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import SwiftUI

struct PackProBadgeComponent: View {
    var body: some View {
        HStack {
            Text("Pro")
                .bold()
                .textCase(.uppercase)
                .font(.caption2)
                .foregroundStyle(.primary)
        }
        .padding(3)
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 4))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.primary, lineWidth: 2)
        )
    }
}

#Preview {
    PackProBadgeComponent()
}
