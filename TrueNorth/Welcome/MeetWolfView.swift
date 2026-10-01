//
//  MeetWolfView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import ParallaxSwiftUI
import SwiftData
import SwiftUI

struct MeetWolfView: View {
    @Binding var isShowingSheet: Bool
    @Query private var wolves: [Wolf]
    @Environment(\.modelContext) private var modelContext
    @State private var hapticTrigger = false

    var body: some View {
        VStack {
            ZStack {
                StarCanvasView()
                    .scaleEffect(1.2)
                    .parallax(amount: 50, direction: .both)
                    .ignoresSafeArea(.all)
                MountainScapeView()
                    .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    WolfSpriteView(animation: .idle)
                        .scaleEffect(3, anchor: .bottom)
                        .padding(.leading, -25)

                }
                ForegroundMountainScapeView()
                    .ignoresSafeArea(.all)
            }
            .background(.northBackground)
            VStack {
                VStack {
                    Text("Meet Wasatch")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 5)
                    Text("Your partner in goal setting")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 40)

                Spacer(minLength: 16)

                HStack {
                    ForEach(Wolf.ColorChoice.allCases.filter { !$0.isPremium })
                    { choice in
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
                        .background(.clear)
                    }
                }

                Spacer(minLength: 1)

                NavigationLink("Continue") {
                    WidgetExploreView(isShowingSheet: $isShowingSheet)
                }
                .buttonSizing(.flexible)
                .font(.title)
                .padding(10)
                .buttonStyle(.glass)
                .padding(.bottom, 0)
                .frame(width: 350)
                .sensoryFeedback(
                    .impact(weight: .medium),
                    trigger: hapticTrigger
                )
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.northBrown)
        }
        .navigationBarBackButtonHidden()
    }
}
