//
//  WolfStyleView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import SwiftData
import SwiftUI
import RevenueCat
import RevenueCatUI

struct WolfStyleView: View {
    
    @State private var displayPaywall = false
    @State private var isPremium: Bool = false
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0),
    ]
    @Environment(EntitlementStore.self) private var entitlements
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
                if(!entitlements.isPremium) {
                                    ForEach(Wolf.ColorChoice.allCases.filter { $0.isPremium }) { choice in
                                        Button {
                                            if let wolf = wolves.first {
                                                wolf.setChoice(choice, isUserPremium: true)
                                            }
                                        } label: {
                                            WolfSelectorComponent(choice: choice, isSelected: wolves.first?.colorChoice == choice)
                                                .background(.clear)
                                        }
                                        .background(Material.regular)
                                        .cornerRadius(20)
                                        .background(.clear)
                                    }
                                } else {
                                    ForEach(Wolf.ColorChoice.allCases.filter { $0.isPremium }) { choice in
                                        Button {
                                            displayPaywall.toggle()
                                        } label: {
                                            
                                            ZStack {
                                                Button {
                                                    if let wolf = wolves.first {
                                                        wolf.setChoice(choice, isUserPremium: false)
                                                    }
                                                } label: {
                                                    WolfSelectorComponent(choice: choice, isSelected: wolves.first?.colorChoice == choice)
                                                        .background(.clear)
                                                }
                                                .background(.clear)
                                                VStack {
                                                    
                                                }
                                                .frame(width: 150, height: 145)
                                                .glassEffect(.clear.tint(.black.opacity(0.75)), in: .rect(cornerRadius: 20))
                                                VStack {
                                                    Spacer()
                                                    HStack {
                                                        Spacer()
                                                        PackProBadgeComponent()
                                                            .scaleEffect(01.1)
                                                            .offset(x: 10, y: 5)
                                                    }
                                                }
                                                .frame(width: 145, height: 145)
                                            }
                                            .sheet(isPresented: $displayPaywall) {
                                                PaywallView()
                                            }
                                        }
                                    }
                                }
            }
            .padding(.top, 50)
        }
        .onAppear {
            Task { await entitlements.checkEntitlement() }
            }

        .navigationTitle("Wolf Style")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    WolfStyleView()
}
