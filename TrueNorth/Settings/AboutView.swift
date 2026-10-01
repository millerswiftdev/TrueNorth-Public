//
//  AboutView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/5/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack {
            ZStack {
                StarCanvasView()
                    .ignoresSafeArea(.all)
                VStack {
                    Spacer()
                    Image("about-mountains")
                        .resizable()
                        .scaledToFit()
                }
                .ignoresSafeArea(.all)

                VStack {
                    Text("Crafted by Jack Miller")
                        .font(.title2)
                        .bold()
                    Text("University of Utah")
                    Image("utah")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .cornerRadius(20)
                        .glassEffect(
                            .regular,
                            in: RoundedRectangle(cornerRadius: 20)
                        )
                    VStack(alignment: .center) {
                        Text(
                            "\"Inspired by the slopes of the Wasatch front, for the goals of creators.\""
                        )
                        .multilineTextAlignment(.center)
                        .padding(10)
                    }
                    .glassEffect(
                        .regular,
                        in: RoundedRectangle(cornerRadius: 20)
                    )
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                }
                .padding(.top, -150)
            }

        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AboutView()
}
