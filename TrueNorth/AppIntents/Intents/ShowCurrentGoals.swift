//
//  ShowCurrentGoals.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/15/26.
//

import AppIntents
import SwiftUI

struct ShowCurrentGoalsIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Current Goals"

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog
        & ShowsSnippetView
    {
        let currentGoals = try await GoalEntity.defaultQuery.suggestedEntities()

        let focusedGoals = Array(currentGoals.prefix(3))

        if focusedGoals.isEmpty {
            return .result(
                dialog: IntentDialog(
                    "You don't have any current goals set right now."
                )
            )
        }

        let titles = focusedGoals.map(\.title).joined(separator: ", ")
        let dialog = IntentDialog("Your focus right now: \(titles).")

        return .result(
            dialog: dialog,
            view: FocusedGoalSnippetView(goals: focusedGoals)
        )
    }
}

struct FocusedGoalSnippetView: View {
    var goals: [GoalEntity]

    var body: some View {
        ZStack {
            StarCanvasView()
                .opacity(0.3)
            VStack {
                HStack {
                    Spacer()
                    Image("wolf-tophat")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 148, height: 148)
                        .opacity(0.3)
                }
            }
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .bottom) {

                    Text("My True North")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.primary)
                }

                VStack(alignment: .leading, spacing: 7) {
                    ForEach(goals, id: \.id) { entity in
                        HStack(spacing: 8) {
                            Text(entity.title)
                                .font(.body)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.northBackground)
        .cornerRadius(16)
    }
}
