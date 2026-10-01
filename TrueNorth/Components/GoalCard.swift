//
//  GoalCard.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/4/26.
//

import Foundation
import SwiftUI

struct GoalCard: View {
    let goal: Goal
    var isDragging: Bool = false

    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "ellipsis")
                    .rotationEffect(Angle(degrees: 90.0))
                    .padding(.leading, 5)
                Spacer()
                VStack {
                    Image(systemName: "ellipsis")
                        .rotationEffect(Angle(degrees: 90.0))
                        .scaleEffect(-1, anchor: .leading)
                        .padding(.trailing, -16)
                }
            }
            .foregroundStyle(.secondary)
            .font(.system(size: 20))
            VStack(alignment: .center) {
                Text(goal.text)
                    .font(.body)
            }
            .padding(5)
        }
        .frame(maxWidth: 300, minHeight: 60, maxHeight: 60)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(.separator)
        )
        .glassEffect(
            .clear.tint(
                (goal.isCurrentGoal ? Color.blue : .clear).opacity(0.5)
            ),
            in: .rect(cornerRadius: 22)
        )
        .padding(.horizontal)
        .contentShape(Rectangle())

    }
}

struct GoalDragCard: View {
    let goal: Goal
    var isDragging: Bool = false

    var body: some View {

        VStack(alignment: .center) {
            Text(goal.text)
                .font(.body)
        }
        .padding(5)
        .frame(maxWidth: 300, minHeight: 60, maxHeight: 60)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(.separator)
        )
        .background(Material.thick)
        .padding(.horizontal)
        .contentShape(Rectangle())

    }
}

struct DemoGoalCard: View {
    let goal: Goal
    var isDragging: Bool = false
    var isCurrentEmpty: Bool

    var body: some View {

        VStack(alignment: .center) {
            if isCurrentEmpty {
                Text("drag a goal here")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
        }
        .padding(5)
        .frame(maxWidth: 300, minHeight: 60, maxHeight: 60)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .strokeBorder(.separator)
        )
        .background(Material.thin)
        .cornerRadius(22)
        .padding(.horizontal)

    }
}

struct ConstructionGoalCard: View {
    @Binding var newGoalText: String
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {

        VStack(alignment: .center) {
            TextField("Enter Goal", text: $newGoalText)
                .focused($isTextFieldFocused)
                .font(.body)
                .padding(7)
                .onChange(of: newGoalText) { _, newValue in
                    if newValue.count > 22 {
                        newGoalText = String(newValue.prefix(26))
                    }
                }
                .onAppear {
                    isTextFieldFocused = true
                }
        }
        .padding(5)
        .frame(maxWidth: 300, minHeight: 60, maxHeight: 60)
        .glassEffect(.regular, in: .rect(cornerRadius: 22))
        .padding(3)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    Color.northBrown,
                    style: StrokeStyle(
                        lineWidth: 10,
                        dash: [20, 5]
                    )
                )
        )
        .cornerRadius(24)
        .padding(.horizontal)

    }
}
