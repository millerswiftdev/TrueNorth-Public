//
//  BulletPointView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/5/26.
//

import SwiftUI

struct BulletPointView: View {
    var text: String
    var symbol: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: symbol)
                    .font(.caption)
            }
            .frame(width: 10)
            Text(text)
                .font(.caption)
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 7)
        .padding(.vertical, 1)
    }
}

#Preview {
    BulletPointView(text: "testing 123", symbol: "paintpalette.fill")
}
