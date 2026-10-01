//
//  SettingsView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/4/26.
//

import Foundation
import SwiftUI
import RevenueCat
import RevenueCatUI
import ParallaxSwiftUI

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
    @Environment(EntitlementStore.self) private var entitlements
    @Environment(\.dismiss) var dismiss
    @State private var displayPaywall = false

    var body: some View {
        NavigationStack {
            List {
                
                if(!entitlements.isPremium) {
                Section {
                    VStack {
                        
                        ZStack {
                            StarCanvasView()
                                .scaleEffect(1.2)
                                .parallax(amount: 30, direction: .both)
                            WolfSpriteView(animation: .howl)
                        }
                        .glassEffect(.regular.tint(.northBackground.opacity(0.5)), in: RoundedRectangle(cornerRadius: 20))
                        .cornerRadius(20)
                        .clipped()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Support The Pack")
                                    .font(.title2)
                                    .bold()
                                    .padding(.top, 5)
                                    .padding(.bottom, 0)
                                VStack(alignment: .leading) {
                                    BulletPointView(text: "More wolf colors", symbol: "paintpalette.fill")
                                    BulletPointView(text: "Customize app icon", symbol: "circle.grid.2x2.topleft.checkmark.filled")
                                }
                                .padding(.top, -3)
                                .padding(.bottom, 2)
                                Button("Upgrade To Pack Pro") {
                                    displayPaywall.toggle()
                                }
                                .buttonStyle(.glassProminent)
                                .tint(.northBlue)
                                .sheet(isPresented: $displayPaywall) {
                                    PaywallView()
                                        .onDisappear() {
                                            Task { await entitlements.checkEntitlement() }
                                        }
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .clipped()
                    
                    .padding(2)
                }
            }

                NavigationLink(destination: WolfStyleView()) {
                    SettingsImageRow(
                        title: "Wolf Style",
                        iconName: "wolf-sunglasses",
                        backgroundColor: .northBackground
                    )
                }
                //                    NavigationLink(destination: IconPickerView()) {
                //                        SettingsRow(title: "Icon", iconName: "square.fill", backgroundColor: .northBackground)
                //                    }

                Section {
                    //                    NavigationLink(destination: AboutView()) {
                    //                        SettingsRow(title: "Pack Pro", iconName: "scribble.variable", backgroundColor: .northBackground)
                    //                    }
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
        .onAppear {
            Task { await entitlements.checkEntitlement() }
            }
    }
}
