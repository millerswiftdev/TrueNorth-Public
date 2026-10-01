//
//  StadiumView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/6/26.
//

import SwiftUI

struct StadiumView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .glassEffect(
                    .clear.tint(.cyan.opacity(0.7)),
                    in: .rect(cornerRadius: 0)
                )

                .frame(width: 400, height: 103)
                .position(x: 200, y: 100)
            Rectangle()
                .fill(.white)

                .frame(width: 400, height: 103)
                .position(x: 200, y: 203)

            RoundedRectangle(cornerRadius: 7)
                .fill(Color(red: 0.86, green: 0.4, blue: 0.27))
                .frame(width: 68, height: 276)
                .position(x: 34, y: 150)

            RoundedRectangle(cornerRadius: 7)
                .fill(Color(red: 0.86, green: 0.4, blue: 0.27))
                .frame(width: 68, height: 276)
                .position(x: 366, y: 150)
        }
        .frame(width: 400, height: 300)
        .clipped()
    }
}

#Preview {
    StadiumView()
}
