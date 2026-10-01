//
//  WolfGreenScreenView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/7/26.
//

import SwiftUI

struct WolfGreenScreenView: View {
    var body: some View {
        VStack {
            WolfSpriteView(animation: .howl)
                .frame(width: 400)
                .padding(50)
        }
        .background(.green)
    }
}

#Preview {
    WolfGreenScreenView()
}
