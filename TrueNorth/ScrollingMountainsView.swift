//
//  ScrollingMountainsView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/4/26.
//

import Foundation
import SwiftUI

struct ScrollingMountainsView: View {
    private let imageName = "mountains-background"
    var scrollDuration: Double = 500  // seconds per tile-width; bigger = slower

    @Binding var animate: Bool

    @State private var accumulatedTime: Double = 0
    @State private var lastTimestamp: Date? = nil

    private var aspectRatio: CGFloat {
        guard let uiImage = UIImage(named: imageName) else { return 3 }
        return uiImage.size.width / uiImage.size.height
    }

    var body: some View {
        GeometryReader { geo in
            let tileWidth = geo.size.height * aspectRatio
            let tileCount = Int(ceil(geo.size.width / tileWidth)) + 2

            TimelineView(.animation) { timeline in
                let offset = currentOffset(
                    at: timeline.date,
                    tileWidth: tileWidth
                )

                HStack(spacing: 0) {
                    ForEach(0..<tileCount, id: \.self) { _ in
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: tileWidth, height: geo.size.height)
                    }
                }
                .offset(x: offset)
                .onChange(of: timeline.date) { _, newDate in
                    guard animate else {
                        lastTimestamp = nil
                        return
                    }
                    if let last = lastTimestamp {
                        accumulatedTime += newDate.timeIntervalSince(last)
                    }
                    lastTimestamp = newDate
                }
            }
        }
    }

    private func currentOffset(at date: Date, tileWidth: CGFloat) -> CGFloat {
        guard tileWidth > 0 else { return 0 }
        let progress =
            accumulatedTime.truncatingRemainder(dividingBy: scrollDuration)
            / scrollDuration
        return -CGFloat(progress) * tileWidth
    }
}
