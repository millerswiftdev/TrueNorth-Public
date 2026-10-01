//
//  StarCanvasView.swift
//  TrueNorth
//
//  Created by Jack Miller + AI Model on 9/6/26.
//

import SwiftUI

struct StarCanvasView: View {
    // Generate star data once so position and twinkle parameters stay consistent
    @State private var stars: [Star] = Star.generateStars(count: 200)

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            Canvas { context, size in
                for star in stars {
                    // Normalize position from relative (0..1) to actual view size
                    let x = star.xRatio * size.width
                    let y = star.yRatio * size.height
                    let rect = CGRect(
                        x: x,
                        y: y,
                        width: star.size,
                        height: star.size
                    )

                    // Calculate a sine-wave opacity based on time, offset, and speed
                    let sineValue = sin(
                        time * star.twinkleSpeed + star.phaseOffset
                    )
                    // Map sine wave (-1...1) to a custom opacity range (e.g., 0.2...1.0)
                    let opacity = 0.2 + (sineValue + 1) / 2 * 0.8

                    context.opacity = opacity
                    context.fill(Path(ellipseIn: rect), with: .color(.white))
                }
            }
        }
    }
}

// Data model for pre-computed star properties
struct Star: Identifiable {
    let id = UUID()
    let xRatio: CGFloat  // Normalized 0...1 relative to view width
    let yRatio: CGFloat  // Normalized 0...1 relative to view height
    let size: CGFloat
    let phaseOffset: Double  // Ensures stars twinkle out of sync
    let twinkleSpeed: Double  // Controls how fast each star flickers

    static func generateStars(count: Int) -> [Star] {
        var rng = SeededGenerator(seed: 42)
        return (0..<count).map { _ in
            Star(
                xRatio: CGFloat.random(in: 0...1, using: &rng),
                yRatio: CGFloat.random(in: 0...1, using: &rng),
                size: CGFloat.random(in: 0.5...1.5, using: &rng),
                phaseOffset: Double.random(in: 0...(2 * .pi), using: &rng),
                twinkleSpeed: Double.random(in: 1.0...3.5, using: &rng)
            )
        }
    }
}

struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: Int) { state = UInt64(seed) }
    mutating func next() -> UInt64 {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        return state
    }
}
