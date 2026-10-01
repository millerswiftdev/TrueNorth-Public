//
//  GoalIntent.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/15/26.
//

import AppIntents
import Foundation
import SwiftData
import SwiftUI
import UniformTypeIdentifiers
import WidgetKit

@AppIntent(schema: .reminders.createReminder)
struct CreateGoalReminderIntent {

    @Parameter(title: "Goal Title")
    var title: String

    @Parameter(title: "Target Goal")
    var list: ReminderListEntity?

    @Parameter(title: "Current Goal")
    var isFlagged: Bool?

    @Parameter(title: "Due Date")
    var dueDate: DateComponents?

    @Parameter(title: "Images", supportedTypeIdentifiers: ["public.image"])
    var images: [IntentFile]

    @Parameter(title: "Location Trigger")
    var locationTrigger: ReminderLocationTriggerEntity?

    @Parameter(title: "Recurrence")
    var recurrence: Calendar.RecurrenceRule?

    @Parameter(title: "Section")
    var section: ReminderSectionEntity?

    // Change [String] to Set<String>
    @Parameter(title: "Tags")
    var tags: Set<String>

    @Parameter(title: "URLs")
    var urls: [URL]

    @Parameter(title: "Notes")
    var note: AttributedString?

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<GoalEntity>
        & ShowsSnippetView
    {
        let pinned = isFlagged ?? false

        if pinned, currentPinnedCount() >= 3 {
            throw PinGoalError.alreadyThreePinned
        }

        let context = GoalEntity.SharedModel.container.mainContext
        let newGoal = Goal(text: title, order: 0, isCurrentGoal: pinned)

        context.insert(newGoal)
        try context.save()

        WidgetCenter.shared.reloadAllTimelines()

        return .result(
            value: GoalEntity(goal: newGoal),
            view: GoalSnippetView(goalText: newGoal.text)
        )
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Create goal \(\.$title) in \(\.$list)") {
            \.$isFlagged
        }
    }

    @MainActor
    private func currentPinnedCount() -> Int {
        let context = GoalEntity.SharedModel.container.mainContext
        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate<Goal> { $0.isCurrentGoal == true }
        )
        return (try? context.fetch(descriptor).count) ?? 0
    }

    struct GoalSnippetView: View {
        let goalText: String

        var body: some View {
            ZStack {
                StarCanvasView()
                    .opacity(0.3)
                VStack(alignment: .center, spacing: 6) {
                    Text("Goal Added To Some Day")
                        .font(.headline)
                    Text(goalText)
                        .font(.body)
                        .lineLimit(2)
                }
                .padding()
            }
            .background(.northBackground)
        }
    }
}

enum PinGoalError: Error, CustomLocalizedStringResourceConvertible {
    case alreadyThreePinned

    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .alreadyThreePinned:
            "You already have 3 current goals. Remove one first."
        }
    }
}
