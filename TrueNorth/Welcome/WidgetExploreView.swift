//
//  WidgetExploreView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import ParallaxSwiftUI
import SwiftData
import SwiftUI

struct WidgetExploreView: View {
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
                        LargePreviewWidgetView()
                            .glassEffect(.clear, in: .rect(cornerRadius: 30))
                            .background(.northBackground)
                            //.shadow(color: .black, radius: 20)
                            .cornerRadius(30)
                        //                        VStack{}
                        //                            .frame(width: 300, height: 340)
                        //
                    }
                    .scaleEffect(0.8)

                }

            }
            .background(.northBackground)
            VStack {
                Spacer(minLength: 1)
                VStack(alignment: .center) {
                    Text("Widgets")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                Image(systemName: "globe.americas")
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
                                Image(systemName: "widget.small.badge.plus")
                                    .font(.system(size: 25))
                                    .frame(width: 40)
                                Text("Add to your lock screen, or home screen")
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
                                        "platter.2.filled.iphone.landscape"
                                )
                                .font(.system(size: 25))
                                .frame(width: 40)
                                Text(
                                    "Keep a close eye with iPhone Standby mode"
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

                NavigationLink("Continue") {
                    SiriView(isShowingSheet: $isShowingSheet)
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
