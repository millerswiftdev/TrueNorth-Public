//
//  SettingsView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/4/26.
//

import Foundation
import SwiftUI

struct SettingsRow: View {
    let title: String
    let iconName: String
    let backgroundColor: Color

    var body: some View {
        Label {
            Text(title)
                .foregroundColor(.primary)
        } icon: {

            VStack {
                Image(systemName: iconName)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 20, height: 20)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                    )
                    .padding(4)
            }
            .glassEffect(
                .regular.tint(backgroundColor),
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
    }
}

struct SettingsImageRow: View {
    let title: String
    let iconName: String
    let backgroundColor: Color

    var body: some View {
        Label {
            Text(title)
                .foregroundColor(.primary)
        } icon: {

            VStack {
                Image(iconName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                    )
                    .padding(4)
            }
            .glassEffect(
                .regular.tint(backgroundColor),
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {

                NavigationLink(destination: WolfStyleView()) {
                    SettingsImageRow(
                        title: "Wolf Style",
                        iconName: "wolf-sunglasses",
                        backgroundColor: .northBackground
                    )
                }
                Section {
                    NavigationLink(destination: AboutView()) {
                        SettingsRow(
                            title: "About",
                            iconName: "quote.bubble.fill",
                            backgroundColor: .northBackground
                        )
                    }
                }

            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Label("Dismiss", systemImage: "xmark")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
