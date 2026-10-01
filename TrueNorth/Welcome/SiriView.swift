//
//  SiriView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import ParallaxSwiftUI
import SwiftData
import SwiftUI

struct SiriView: View {
    @Binding var isShowingSheet: Bool
    @Query private var wolves: [Wolf]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
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
                ForegroundMountainScapeView()
                    .ignoresSafeArea(.all)
                VStack {
                    ZStack {
                        Image(systemName: "siri")
                            .font(.system(size: 108))
                            .padding(30)
                            .glassEffect(.clear, in: .rect(cornerRadius: 30))
                            .background(.northBackground)
                            .cornerRadius(30)
                    }
                    .scaleEffect(1.3)

                }

            }
            .background(.northBackground)
            VStack {
                Spacer(minLength: 1)
                VStack(alignment: .center) {
                    Text("Siri AI")
                        .font(.system(size: 60))
                        .bold()
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Image(systemName: "person.wave.2")
                                    .frame(width: 40)
                                    .font(.system(size: 25))
                                Text(
                                    "Let Wasatch guide you everywhere on your phone"
                                )
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(size: 17))
                                Spacer()
                            }
                            .foregroundStyle(Color.secondary)
                            .padding(.bottom, 10)

                            HStack {
                                Image(systemName: "plus.capsule")
                                    .font(.system(size: 25))
                                    .frame(width: 40)
                                Text("Ask to create a reminder in True North")
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(
                                        horizontal: false,
                                        vertical: true
                                    )
                                    .font(.system(size: 17))
                                Spacer()
                            }
                            .padding(.bottom, 10)
                            .foregroundStyle(Color.secondary)

                            HStack {
                                Image(
                                    systemName:
                                        "person.fill.questionmark"
                                )
                                .font(.system(size: 25))
                                .frame(width: 40)
                                Text(
                                    "Ask what your True North goals are"
                                )
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(size: 17))
                                Spacer()
                            }
                            .foregroundStyle(Color.secondary)
                        }
                        .padding(12)
                        .frame(maxWidth: 310, alignment: .center)
                        .background(Material.thin)
                        .cornerRadius(25)
                        Spacer()
                    }

                    Spacer()
                }
                .padding(.top, 40)

                Spacer(minLength: 1)

                Button("Continue") {
                    isShowingSheet = false
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
//
//#Preview {
//    WidgetExploreView()
//}
