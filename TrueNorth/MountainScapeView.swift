//
//  MountainScapeView.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import SwiftUI

struct RoundedTriangle: Shape {
    var cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let top = CGPoint(x: rect.midX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        let startPoint = CGPoint(
            x: (bottomLeft.x + top.x) / 2,
            y: (bottomLeft.y + top.y) / 2
        )
        path.move(to: startPoint)

        path.addArc(
            tangent1End: top,
            tangent2End: bottomRight,
            radius: cornerRadius
        )
        path.addArc(
            tangent1End: bottomRight,
            tangent2End: bottomLeft,
            radius: cornerRadius - 5
        )
        path.addArc(
            tangent1End: bottomLeft,
            tangent2End: top,
            radius: cornerRadius - 5
        )

        path.closeSubpath()
        return path
    }
}

struct GlassMountainView: View {
    var body: some View {
        VStack {}
            .frame(width: 200, height: 200)
            .glassEffect(
                .regular.tint(.northBlue.opacity(0.1)),
                in: RoundedTriangle(cornerRadius: 14)
            )
    }
}

struct MountainScapeView: View {

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                GlassMountainView()
                    .padding(.leading, 200)
                    .scaleEffect(1.5, anchor: .bottom)
                GlassMountainView()
                    .padding(.leading, 160)
                    .scaleEffect(1.1, anchor: .bottom)
                GlassMountainView()
                    .padding(.leading, 0)
                    .scaleEffect(1.5, anchor: .bottom)
                GlassMountainView()
                    .padding(.leading, -90)
                    .scaleEffect(0.8, anchor: .bottom)
            }
        }

        .frame(maxHeight: .infinity)
    }
}

struct LongMountainScapeView: View {

    var body: some View {
        VStack {
            Spacer()
            HStack {
                MountainScapeView()
                    .scaleEffect(0.5, anchor: .bottom)
                    .frame(width: 100)
                MountainScapeView()
                    .scaleEffect(0.6, anchor: .bottom)
                    .frame(width: 100)
                MountainScapeView()
                    .scaleEffect(0.2, anchor: .bottom)
                    .frame(width: 100)
                MountainScapeView()
                    .scaleEffect(0.3, anchor: .bottom)
                    .frame(width: 100)
                MountainScapeView()
                    .scaleEffect(0.5, anchor: .bottom)
                    .frame(width: 100)
                MountainScapeView()
                    .scaleEffect(0.3, anchor: .bottom)
                    .frame(width: 100)
            }
            .frame(height: 200)
        }
        .frame(width: 800)
        .clipped()
    }
}

struct ForegroundMountainScapeView: View {

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                GlassMountainView()
                    .padding(.leading, -220)
                    .scaleEffect(1.3, anchor: .bottom)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct ForegroundAltMountainScapeView: View {

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                GlassMountainView()
                    .padding(.leading, -220)
                    .scaleEffect(1.3, anchor: .bottom)
                GlassMountainView()
                    .padding(.leading, -90)
                    .scaleEffect(0.8, anchor: .bottom)
                GlassMountainView()
                    .padding(.leading, 160)
                    .scaleEffect(0.9, anchor: .bottom)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    LongMountainScapeView()
}
