//
//  WolfSpriteView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import SwiftData
import SwiftUI
import UIKit
import WidgetKit

enum WolfAnimation: String, CaseIterable, Identifiable {
    case idle
    case walk
    case pounce
    case growl
    case attack
    case howl
    case hurt
    case sleep

    var id: String { rawValue }

    var row: Int {
        switch self {
        case .idle: return 0
        case .walk: return 1
        case .pounce: return 2
        case .growl: return 3
        case .attack: return 4
        case .howl: return 5
        case .hurt: return 6
        case .sleep: return 7
        }
    }

    var frameCount: Int {
        switch self {
        case .idle: return 4
        case .walk: return 6
        case .pounce: return 5
        case .growl: return 6
        case .attack: return 6
        case .howl: return 10
        case .hurt: return 3
        case .sleep: return 5
        }
    }

    var frameDuration: Double {
        switch self {
        case .idle: return 0.35
        case .walk: return 0.09
        case .howl: return 0.12
        case .hurt: return 0.08
        case .sleep: return 0.2
        default: return 0.1
        }
    }

    var loops: Bool {
        switch self {
        case .idle, .walk:
            return true
        case .pounce, .growl, .attack, .howl, .hurt, .sleep:
            return false
        }
    }

    var hapticFrames: [Int: HapticEvent] {
        switch self {
        case .idle, .walk:
            return [:]
        case .pounce:
            return [0: .impact(.light), 3: .impact(.heavy)]
        case .growl:
            return [3: .impact(.rigid)]
        case .attack:
            return [3: .impact(.heavy)]
        case .howl:
            return [0: .impact(.soft), 6: .notification(.success)]
        case .hurt:
            return [0: .notification(.error)]
        case .sleep:
            return [0: .impact(.heavy), 4: .notification(.warning)]
        }
    }
}

enum HapticEvent {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
}

func fireHaptic(_ event: HapticEvent) {
    switch event {
    case .impact(let style):
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare()
        gen.impactOccurred()
    case .notification(let type):
        let gen = UINotificationFeedbackGenerator()
        gen.prepare()
        gen.notificationOccurred(type)
    case .selection:
        let gen = UISelectionFeedbackGenerator()
        gen.prepare()
        gen.selectionChanged()
    }
}

struct WolfSpriteView: View {
    @Query private var wolves: [Wolf]

    let animation: WolfAnimation
    var scale: CGFloat = 4
    private let sheetColumns = 10
    private let sheetRows = 8
    private let frameSize = CGSize(width: 32, height: 32)

    @State private var startDate = Date()

    var body: some View {
        let frameW = frameSize.width * scale
        let frameH = frameSize.height * scale
        let colorName = wolves.first?.colorChoice.swiftName ?? "grey"

        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let frame = frameIndex(elapsed: elapsed)

            Image("wolf-" + colorName)
                .interpolation(.none)
                .resizable()
                .frame(
                    width: frameW * CGFloat(sheetColumns),
                    height: frameH * CGFloat(sheetRows)
                )
                .offset(
                    x: -CGFloat(frame) * frameW,
                    y: -CGFloat(animation.row) * frameH
                )
                .frame(width: frameW, height: frameH, alignment: .topLeading)
                .clipped()
                .onChange(of: frame) { newFrame in
                    if let event = animation.hapticFrames[newFrame] {
                        fireHaptic(event)
                    }
                }
        }
        .onChange(of: animation) { newAnimation in
            startDate = Date()
            if let event = newAnimation.hapticFrames[0] {
                fireHaptic(event)
            }
        }
        .onAppear {
            startDate = Date()
        }
    }

    private func frameIndex(elapsed: TimeInterval) -> Int {
        let count = animation.frameCount
        let raw = Int(elapsed / animation.frameDuration)
        if animation.loops {
            return raw % count
        } else {
            return min(raw, count - 1)
        }
    }
}

struct WolfDemoView: View {
    @State private var animation: WolfAnimation = .idle

    var body: some View {
        VStack(spacing: 28) {
            WolfSpriteView(animation: animation, scale: 6)
                .frame(width: 128, height: 128)
                .background(Color.gray.opacity(0.15))

            Text(animation.rawValue.capitalized)
                .font(.headline)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 4),
                spacing: 8
            ) {
                ForEach(WolfAnimation.allCases) { anim in
                    Button(anim.rawValue.capitalized) {
                        animation = anim
                    }
                    .buttonStyle(.bordered)
                    .tint(anim == animation ? .accentColor : .gray)
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct WolfSingleFrameView: View {
    @Query private var wolves: [Wolf]
    let row: Int
    let column: Int

    var scale: CGFloat = 4

    private let sheetColumns = 10
    private let sheetRows = 8
    private let frameSize = CGSize(width: 32, height: 32)

    var body: some View {
        let colorName = wolves.first?.colorChoice.swiftName ?? "grey"
        let imageName = "wolf-" + colorName
        let frameW = frameSize.width * scale
        let frameH = frameSize.height * scale

        let safeRow = max(0, min(row, sheetRows - 1))
        let safeCol = max(0, min(column, sheetColumns - 1))

        Image(imageName)

            .interpolation(.none)

            .resizable()
            .widgetAccentedRenderingMode(.accentedDesaturated)
            .frame(
                width: frameW * CGFloat(sheetColumns),
                height: frameH * CGFloat(sheetRows)
            )
            .offset(
                x: -CGFloat(safeCol) * frameW,
                y: -CGFloat(safeRow) * frameH
            )
            .frame(width: frameW, height: frameH, alignment: .topLeading)
            .clipped()

    }
}

struct WolfPickerSingleFrameView: View {
    let row: Int
    let column: Int
    let color: String

    var scale: CGFloat = 4

    private let sheetColumns = 10
    private let sheetRows = 8
    private let frameSize = CGSize(width: 32, height: 32)

    var body: some View {
        let imageName = "wolf-" + color
        let frameW = frameSize.width * scale
        let frameH = frameSize.height * scale

        let safeRow = max(0, min(row, sheetRows - 1))
        let safeCol = max(0, min(column, sheetColumns - 1))

        Image(imageName)
            .interpolation(.none)
            .resizable()
            .frame(
                width: frameW * CGFloat(sheetColumns),
                height: frameH * CGFloat(sheetRows)
            )
            .offset(
                x: -CGFloat(safeCol) * frameW,
                y: -CGFloat(safeRow) * frameH
            )
            .frame(width: frameW, height: frameH, alignment: .bottomLeading)
            .clipped()

    }
}

struct SleepingWolf: View {
    var body: some View {
        ZStack {
            Image(systemName: "zzz")
                .frame(width: 40)
                .offset(x: 29, y: 25)
                .foregroundStyle(.background)
                .symbolEffect(.breathe)
            WolfSingleFrameView(row: 7, column: 4)
                .frame(maxWidth: 100, maxHeight: 100)
                .padding(.bottom, 14)
        }
    }
}

#Preview {
    WolfDemoView()
}
