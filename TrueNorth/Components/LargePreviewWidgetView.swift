//
//  LargePreviewWidgetView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/13/26.
//

import SwiftUI

struct LargePreviewWidgetView: View {
    let demoGoals: [String] = [
        "Get a 4.0 In School", "Develop a wonderful App",
        "Get a 2027 Internship",
    ]
    let row = Int.random(in: 0...4)
    let col = Int.random(in: 1...3)
    let row2 = Int.random(in: 0...4)
    let col2 = Int.random(in: 1...4)

    var body: some View {
        ZStack {
            StarCanvasView()
                .opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                HStack {
                    if false {
                        ZStack {
                            WolfSingleFrameView(row: 7, column: 4)
                                .scaleEffect(1.7, anchor: .bottom)
                            Image(systemName: "zzz")
                                .frame(width: 60)
                                .offset(x: 29, y: 20)
                                .foregroundStyle(.secondary)
                                .symbolEffect(.breathe)
                        }
                        .padding(.leading, 40)
                    } else {
                        HStack {
                            WolfSingleFrameView(row: row, column: col)
                                .scaleEffect(2.4, anchor: .bottom)
                                .frame(maxWidth: 150, maxHeight: 150)
                                .padding(.bottom, -5)
                                .padding(.leading, -60)
                            WolfSingleFrameView(row: row2, column: col2)
                                .scaleEffect(x: -2.4, y: 2.4, anchor: .bottom)
                                .frame(maxWidth: 150, maxHeight: 150)
                                .padding(.bottom, -5)
                                .padding(.leading, 60)
                        }
                    }
                    Spacer()
                }
            }
            HStack {

                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            if false {
                                HStack {
                                    Text("No goals yet")
                                        .font(.system(size: 25))
                                        .bold()
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            } else {
                                ForEach(
                                    Array(demoGoals.enumerated()),
                                    id: \.offset
                                ) { index, goal in
                                    HStack {
                                        Text(goal)
                                            .font(
                                                .system(
                                                    size: 25 - Double(index * 2)
                                                )
                                            )
                                            .opacity(
                                                max(
                                                    1.0 - (Double(index) * 0.2),
                                                    0.3
                                                )
                                            )
                                            .bold()
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.bottom, (2 + Double(index + 2)))
                                }
                            }
                        }
                    }
                    .padding(12)
                    .padding(.bottom, 70)
                }

            }
        }
        .frame(width: 300, height: 340)
        .clipped()
    }
}

#Preview {
    LargePreviewWidgetView()
        .background(.purple)
}
