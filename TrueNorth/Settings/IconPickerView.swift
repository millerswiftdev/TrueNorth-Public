//
//  IconPickerView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/14/26.
//

import SwiftUI

struct IconPickerView: View {
    let icons: [(name: String, assetName: String?)] = [
        ("Original", nil),
        ("Cool", "TrueNorthIconCool"),
    ]

    @State private var selectedIcon: String? = nil

    var body: some View {
        Picker("Select Icon", selection: $selectedIcon) {
            ForEach(icons, id: \.assetName) { icon in
                Text(icon.name).tag(icon.assetName)
            }
        }
        .onChange(of: selectedIcon) { newIconName in
            DispatchQueue.main.async {
                UIApplication.shared.setAlternateIconName(newIconName) {
                    error in
                    if let error = error {
                        print(
                            "Failed to change \(newIconName): \(error.localizedDescription)"
                        )
                    } else {
                        print(
                            "Successfully changed icon to: \(newIconName ?? "Primary")"
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    IconPickerView()
}
