//
//  GoalEntity.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/15/26.
//

import AppIntents
import CoreLocation
internal import CoreSpotlight
import Foundation
import SwiftData

@AppEntity(schema: .reminders.reminder)
struct GoalEntity: IndexedEntity {
    enum SharedModel {
        static let container: ModelContainer = {
            let config = ModelConfiguration(
                groupContainer: .identifier("group.com.jackmiller.TrueNorth")
            )
            return try! ModelContainer(
                for: Goal.self,
                Wolf.self,
                configurations: config
            )
        }()
    }

    static let defaultQuery = GoalEntityQuery()

    let id: UUID

    @Property(indexingKey: \.title)
    var title: String

    var note: AttributedString? { nil }
    var images: [IntentFile] { [] }
    var subtasks: [GoalEntity] { [] }
    var tags: Set<String> { [] }
    var urls: [URL] { [] }
    var dueDate: DateComponents? { nil }
    var recurrence: Calendar.RecurrenceRule? { nil }
    var isCompleted: Bool { false }

    var list: ReminderListEntity
    var section: ReminderSectionEntity? { nil }
    var locationTrigger: ReminderLocationTriggerEntity? { nil }
    var creationDate: Date? { nil }
    var completionDate: Date? { nil }

    private var goal: Goal

    var isFlagged: Bool? {
        goal.isCurrentGoal
    }

    init(goal: Goal) {
        self.goal = goal
        self.id = goal.id
        self.title = goal.text
        self.list = ReminderListEntity(name: "Goals")
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    struct GoalEntityQuery: EnumerableEntityQuery, EntityStringQuery {
        @MainActor
        func entities(for identifiers: [GoalEntity.ID]) async throws
            -> [GoalEntity]
        {
            let context = SharedModel.container.mainContext
            let allGoals = try context.fetch(FetchDescriptor<Goal>())
            let idSet = Set(identifiers)
            return allGoals.filter { idSet.contains($0.id) }.map {
                GoalEntity(goal: $0)
            }
        }

        @MainActor
        func entities(matching string: String) async throws -> [GoalEntity] {
            let context = SharedModel.container.mainContext
            let descriptor = FetchDescriptor<Goal>(
                predicate: #Predicate<Goal> {
                    $0.text.localizedStandardContains(string)
                }
            )
            return try context.fetch(descriptor).map { GoalEntity(goal: $0) }
        }

        @MainActor
        func allEntities() async throws -> [GoalEntity] {
            let context = SharedModel.container.mainContext
            let descriptor = FetchDescriptor<Goal>(sortBy: [
                SortDescriptor(\.order)
            ])
            return try context.fetch(descriptor).map { GoalEntity(goal: $0) }
        }

        @MainActor
        func suggestedEntities() async throws -> [GoalEntity] {
            try await allEntities().filter { $0.isFlagged == true }
        }
    }
}

@AppEntity(schema: .reminders.list)
struct ReminderListEntity: TransientAppEntity {
    static let defaultQuery = ReminderListEntityQuery()

    let id: UUID
    var name: String

    var type: ListType

    init() {
        self.id = UUID()
        self.name = "Goals"
        self.type = .standard
    }

    init(id: UUID = UUID(), name: String, type: ListType = .standard) {
        self.id = id
        self.name = name
        self.type = type
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    struct ReminderListEntityQuery: EntityQuery {
        func entities(for identifiers: [ReminderListEntity.ID]) async throws
            -> [ReminderListEntity]
        {
            []
        }
    }
}

@AppEntity(schema: .reminders.section)
struct ReminderSectionEntity: TransientAppEntity {
    static let defaultQuery = ReminderSectionEntityQuery()

    let id: UUID
    var name: String
    var list: ReminderListEntity

    init() {
        self.id = UUID()
        self.name = ""
        self.list = ReminderListEntity()
    }

    init(
        id: UUID = UUID(),
        name: String,
        list: ReminderListEntity = ReminderListEntity()
    ) {
        self.id = id
        self.name = name
        self.list = list
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    struct ReminderSectionEntityQuery: EntityQuery {
        func entities(for identifiers: [ReminderSectionEntity.ID]) async throws
            -> [ReminderSectionEntity]
        {
            []
        }
    }
}

@AppEntity(schema: .reminders.locationTrigger)
struct ReminderLocationTriggerEntity: TransientAppEntity {
    static let defaultQuery = ReminderLocationTriggerEntityQuery()

    let id: UUID

    var place: CLPlacemark
    var event: LocationTriggerEvent

    init() {
        self.id = UUID()
    }

    init(id: UUID) {
        self.id = id
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "Location Trigger")
    }

    struct ReminderLocationTriggerEntityQuery: EntityQuery {
        func entities(for identifiers: [ReminderLocationTriggerEntity.ID])
            async throws -> [ReminderLocationTriggerEntity]
        {
            []
        }
    }
}

// MARK: - Schema Enums Bound via AppSchema Macro

@AppEnum(schema: .reminders.listType)
enum ListType: String, AppEnum {
    case standard
    case smart

    static var caseDisplayRepresentations: [ListType: DisplayRepresentation] = [
        .standard: "Standard",
        .smart: "Smart",
    ]
}

@AppEnum(schema: .reminders.locationTriggerEvent)
enum LocationTriggerEvent: String, AppEnum {
    case arrive
    case depart

    static var caseDisplayRepresentations:
        [LocationTriggerEvent: DisplayRepresentation] = [
            .arrive: "Arrive",
            .depart: "Depart",
        ]
}
