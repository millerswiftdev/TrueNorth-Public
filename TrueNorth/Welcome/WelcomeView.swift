//
//  WelcomeView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import ParallaxSwiftUI
import SwiftUI

struct WelcomeView: View {
    @Binding var isShowingSheet: Bool
    @State private var hapticTrigger = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack {
                    ZStack {
                        StarCanvasView()
                            .scaleEffect(1.2)
                            .parallax(amount: 50, direction: .both)
                            .ignoresSafeArea(.all)
                        MountainScapeView()
                            .ignoresSafeArea(.all)
                        VStack {
                            Text("True")
                                .font(.system(size: 50))
                                .fontWidth(.expanded)
                                .bold()
                                .padding(.bottom, -45)
                            Text("North")
                                .font(.system(size: 90))
                                .bold()
                        }
                        .padding(.top, -40)
                        ForegroundAltMountainScapeView()
                            .ignoresSafeArea(.all)
                    }
                }
                .background(.northBackground)
                VStack {
                    VStack {

                    }
                    .padding(0)
                    .frame(height: 10)
                    .frame(maxWidth: .infinity)
                    .background(.black)
                    ZStack {
                        WolfStampedeView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .allowsHitTesting(false)
                            .ignoresSafeArea()
                            .padding(.top, -350)

                        VStack {
                            Spacer()
                            NavigationLink("Continue") {
                                MeetWolfView(isShowingSheet: $isShowingSheet)
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
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.northBrown)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    WelcomeView()
//}
