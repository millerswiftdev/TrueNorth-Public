//
//  StampedeView.swift
//  TrueNorth
//
//  Created by Jack Miller + AI Model on 9/7/26.
//

public import Combine
import SwiftUI

struct StampedeWolf: Identifiable {
    let id = UUID()
    let depth: CGFloat
    let lane: CGFloat
    let startDelay: Double
}

struct WolfStampedeView: View {
    let wolves: [StampedeWolf]
    let height: CGFloat
    let duration: Double
    let spriteSize: CGFloat

    @State private var hapticTriggerPrimary: Int = 0
    @State private var hapticTriggerSecondary: Int = 0
    @State private var activeRatio: Double = 0.0
    private let referenceDate = Date()

    // Faster 45ms timer for a continuous high-frequency rumble
    private let hapticTimer = Timer.publish(
        every: 0.075,
        on: .main,
        in: .common
    ).autoconnect()

    init(
        count: Int = 4,
        height: CGFloat = 900,
        spriteSize: CGFloat = 464,
        duration: Double = 6.0,
        entryJitter: Double = 9
    ) {
        self.height = height
        self.spriteSize = spriteSize
        self.duration = duration

        self.wolves = (0..<count)
            .map { i in
                StampedeWolf(
                    depth: .random(in: 0...1),
                    lane: .random(in: 0...2),
                    startDelay: i == 0 ? 0 : .random(in: 0...entryJitter)
                )
            }
            .sorted { $0.depth < $1.depth }
    }

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSince(referenceDate)
                let activeCount = wolves.filter { wolf in
                    elapsed >= wolf.startDelay
                }.count

                let ratio = Double(activeCount) / Double(max(wolves.count, 1))
                let _ = DispatchQueue.main.async {
                    if self.activeRatio != ratio {
                        self.activeRatio = ratio
                    }
                }

                ZStack {
                    ForEach(wolves) { wolf in
                        if elapsed >= wolf.startDelay {
                            wolfSprite(
                                for: wolf,
                                elapsed: elapsed,
                                totalWidth: geo.size.width
                            )
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .clipped()
        .sensoryFeedback(trigger: hapticTriggerPrimary) { _, _ in
            guard activeRatio > 0 else { return nil }
            return .impact(
                weight: .heavy,
                intensity: min(activeRatio * 1.5, 1.0)
            )
        }
        .sensoryFeedback(trigger: hapticTriggerSecondary) { _, _ in
            guard activeRatio > 0.3 else { return nil }
            return .alignment
        }
        .onReceive(hapticTimer) { _ in
            if activeRatio > 0 {
                hapticTriggerPrimary += 1
                if activeRatio > 0.3 {
                    hapticTriggerSecondary += 1
                }
            }
        }
    }

    @ViewBuilder
    private func wolfSprite(
        for wolf: StampedeWolf,
        elapsed: Double,
        totalWidth: CGFloat
    ) -> some View {
        let xPosition = calculateX(
            elapsed: elapsed,
            wolf: wolf,
            totalWidth: totalWidth
        )
        let yPosition = calculateY(wolf: wolf)

        WolfSpriteView(animation: .walk, scale: 10.0)
            .clipped()
            .position(x: xPosition, y: yPosition)
    }

    private func calculateX(
        elapsed: Double,
        wolf: StampedeWolf,
        totalWidth: CGFloat
    ) -> CGFloat {
        let activeTime = elapsed - wolf.startDelay
        guard activeTime >= 0 else {
            return -spriteSize
        }

        let loopedTime = activeTime.truncatingRemainder(dividingBy: duration)
        let progress = loopedTime / duration

        let totalTravel = totalWidth + (spriteSize * 2)
        return -spriteSize + (progress * totalTravel)
    }

    private func calculateY(wolf: StampedeWolf) -> CGFloat {
        let halfSprite = spriteSize / 2
        let usableHeight = max(height - spriteSize, 0)

        let depthY = halfSprite + (wolf.depth * usableHeight)

        let jitterRange = usableHeight * 0.15
        let scatterOffset = (wolf.lane - 1.0) * jitterRange

        let rawY = depthY + scatterOffset
        return min(max(rawY, halfSprite), height - halfSprite)
    }
}

#Preview {
    WolfStampedeView(count: 100, height: 800)
        .background(Color.brown.opacity(0.15))
}
