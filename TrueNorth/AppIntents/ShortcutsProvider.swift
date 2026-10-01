//
//  ShortcutsProvider.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/15/26.
//

import AppIntents
import Foundation

struct TrueNorthShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowCurrentGoalsIntent(),
            phrases: [
                "Show my \(.applicationName) goals",
                "What are my current goals in \(.applicationName)",
                "What are my \(.applicationName) goals",
                "Show current goals in \(.applicationName)",
                "What are my goals in \(.applicationName)",
                "\(.applicationName) goals",
                "Show me my \(.applicationName) goals",
                "\(.applicationName) focus",
                "What is my \(.applicationName)",
            ],
            shortTitle: "Current Goals",
            systemImageName: "flag.fill"
        )
        AppShortcut(
            intent: CreateGoalReminderIntent(),
            phrases: [
                "Create a goal in \(.applicationName)",
                "Add a goal to \(.applicationName)",
                "New goal in \(.applicationName)",
                "Set a goal in \(.applicationName)",
            ],
            shortTitle: "Create Goal",
            systemImageName: "star.fill"
        )
    }

    static var shortcutTileColor: ShortcutTileColor = .blue
}
