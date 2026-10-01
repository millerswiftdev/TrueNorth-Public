//
//  TrueNorthWidget.swift
//  TrueNorthWidget
//
//  Created by Jack Miller on 9/3/26.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let goals: [Goal]
}

struct Provider: AppIntentTimelineProvider {
    // Helper property to create the shared container
    private var container: ModelContainer = {
        let config = ModelConfiguration(
            groupContainer: .identifier("group.com.jackmiller.TrueNorth")
        )
        return try! ModelContainer(for: Goal.self, configurations: config)
    }()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            goals: []
        )
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> SimpleEntry {
        let goals = await (try? fetchGoals()) ?? []
        return SimpleEntry(
            date: Date(),
            configuration: configuration,
            goals: goals
        )
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<SimpleEntry> {
        let goals = await (try? fetchGoals()) ?? []
        let calendar = Calendar.current
        let now = Date()

        let refreshHours = [8, 12, 16, 20]

        var entryDates: [Date] = refreshHours.compactMap { hour in
            calendar.date(bySettingHour: hour, minute: 0, second: 0, of: now)
        }

        entryDates = entryDates.filter { $0 > now }

        if entryDates.isEmpty || entryDates.first! > now.addingTimeInterval(60)
        {
            entryDates.insert(now, at: 0)
        }

        let entries = entryDates.map { date in
            SimpleEntry(date: date, configuration: configuration, goals: goals)
        }

        let nextMidnight =
            calendar.nextDate(
                after: now,
                matching: DateComponents(hour: 0, minute: 0),
                matchingPolicy: .nextTime
            ) ?? now.addingTimeInterval(86400)

        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        return timeline
    }

    @MainActor
    private func fetchGoals() throws -> [Goal] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate { $0.isCurrentGoal },
            sortBy: [SortDescriptor(\.order)]
        )
        return try context.fetch(descriptor)
    }
}

// MARK: - Entry view dispatcher

struct TrueNorthWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        case .accessoryRectangular:
            AccessoryRectangularView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Small

struct SmallWidgetView: View {

    var entry: Provider.Entry

    var body: some View {
        ZStack {
            StarCanvasView()
                .opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                HStack {
                    if entry.goals.count == 0 {
                        ZStack {
                            WolfSingleFrameView(row: 7, column: 4)
                                .scaleEffect(1.7, anchor: .bottom)
                            Image(systemName: "zzz")
                                .frame(width: 60)
                                .offset(x: 29, y: 20)
                                .foregroundStyle(.secondary)
                                .symbolEffect(.breathe)
                        }
                    } else {
                        WolfSingleFrameView(row: 2, column: 1)
                            .scaleEffect(2.4, anchor: .bottom)
                            .frame(maxWidth: 150, maxHeight: 150)
                            .padding(.bottom, -65)
                            .padding(.leading, -40)
                    }
                    Spacer()
                }
            }

            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            if entry.goals.isEmpty {
                                HStack {
                                    Text("No goals yet")
                                        .font(.system(size: 11))
                                        .bold()
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)

                                    Spacer()
                                }
                            } else {
                                ForEach(
                                    Array(entry.goals.prefix(3).enumerated()),
                                    id: \.element.id
                                ) { index, goal in
                                    HStack {
                                        Text("\(goal.text)")
                                            .font(
                                                .system(
                                                    size: 11 - Double(index)
                                                )
                                            )
                                            .opacity(
                                                max(
                                                    1.0 - (Double(index) * 0.2),
                                                    0.3
                                                )
                                            )
                                            .bold()
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.bottom, 1)
                                }
                            }
                        }

                        Spacer()
                    }
                    .padding(.leading, 12)
                    .padding(.top, 12)
                    .padding(.top, 10)
                    Spacer()
                }

            }
        }
    }
}

// MARK: - Medium

struct MediumWidgetView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            StarCanvasView()
                .opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                VStack {
                    Spacer()
                    HStack {
                        if entry.goals.count == 0 {
                            ZStack {
                                WolfSingleFrameView(row: 7, column: 4)
                                    .scaleEffect(1.7, anchor: .bottom)
                                Image(systemName: "zzz")
                                    .frame(width: 60)
                                    .offset(x: 29, y: 20)
                                    .foregroundStyle(.secondary)
                                    .symbolEffect(.breathe)
                            }
                            .padding(.leading, 40)
                        } else {
                            WolfSingleFrameView(row: 2, column: 1)
                                .scaleEffect(2.4, anchor: .bottom)
                                .frame(maxWidth: 150, maxHeight: 150)
                                .padding(.bottom, -5)
                                .padding(.leading, -10)
                        }
                        Spacer()
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            if entry.goals.isEmpty {
                                HStack {
                                    Text("No goals yet")
                                        .font(.system(size: 12))
                                        .bold()
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            } else {
                                ForEach(
                                    Array(entry.goals.prefix(3).enumerated()),
                                    id: \.element.id
                                ) { index, goal in
                                    HStack {
                                        Text("\(goal.text)")
                                            .font(
                                                .system(
                                                    size: 12 - Double(index)
                                                )
                                            )
                                            .opacity(
                                                max(
                                                    1.0 - (Double(index) * 0.2),
                                                    0.3
                                                )
                                            )
                                            .bold()
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.bottom, 1)
                                }
                            }
                        }
                    }
                    .padding(12)
                }

            }
        }
    }
}

// MARK: - Large

struct LargeWidgetView: View {
    var entry: Provider.Entry
    let row = Int.random(in: 0...4)
    let col = Int.random(in: 1...3)
    let row2 = Int.random(in: 0...4)
    let col2 = Int.random(in: 1...4)

    var body: some View {
        ZStack {
            StarCanvasView()
                .opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                HStack {
                    if entry.goals.count == 0 {
                        ZStack {
                            WolfSingleFrameView(row: 7, column: 4)
                                .scaleEffect(1.7, anchor: .bottom)
                            Image(systemName: "zzz")
                                .frame(width: 60)
                                .offset(x: 29, y: 20)
                                .foregroundStyle(.secondary)
                                .symbolEffect(.breathe)
                        }
                        .padding(.leading, 40)
                    } else {
                        HStack {
                            WolfSingleFrameView(row: row, column: col)
                                .scaleEffect(2.4, anchor: .bottom)
                                .frame(maxWidth: 150, maxHeight: 150)
                                .padding(.bottom, -5)
                                .padding(.leading, -60)
                            WolfSingleFrameView(row: row2, column: col2)
                                .scaleEffect(x: -2.4, y: 2.4, anchor: .bottom)
                                .frame(maxWidth: 150, maxHeight: 150)
                                .padding(.bottom, -5)
                                .padding(.leading, 60)
                        }
                    }
                    Spacer()
                }
            }
            HStack {

                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            if entry.goals.isEmpty {
                                HStack {
                                    Text("No goals yet")
                                        .font(.system(size: 25))
                                        .bold()
                                        .lineLimit(1)
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                }
                            } else {
                                ForEach(
                                    Array(entry.goals.prefix(3).enumerated()),
                                    id: \.element.id
                                ) { index, goal in
                                    HStack {
                                        Text("\(goal.text)")
                                            .font(
                                                .system(
                                                    size: 25 - Double(index * 2)
                                                )
                                            )
                                            .opacity(
                                                max(
                                                    1.0 - (Double(index) * 0.2),
                                                    0.3
                                                )
                                            )
                                            .bold()
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.bottom, (2 + Double(index + 2)))
                                }
                            }
                        }
                    }
                    .padding(12)
                    .padding(.bottom, 70)
                }

            }
        }
    }
}

// MARK: - Accessory Rectangular (Lock Screen)

struct AccessoryRectangularView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            HStack(alignment: .bottom) {
                Spacer()
                Image("wolf-sunglasses-widget")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.4)
                    .frame(width: 40, height: 40)
                    .widgetAccentable()
            }
            HStack(spacing: 6) {

                Image(systemName: entry.goals.isEmpty ? "moon.zzz.fill" : "")
                    .font(.system(size: 16))
                    .widgetAccentable()

                VStack(alignment: .leading, spacing: 1) {
                    if entry.goals.isEmpty {
                        Text("No goals yet")
                            .font(.system(size: 13, weight: .semibold))
                            .lineLimit(1)
                    } else {
                        ForEach(
                            Array(entry.goals.prefix(3).enumerated()),
                            id: \.element.id
                        ) { index, goal in
                            Text(goal.text)
                                .font(
                                    .system(
                                        size: index == 0 ? 13 : 11,
                                        weight: index == 0
                                            ? .semibold : .regular
                                    )
                                )
                                .opacity(index == 0 ? 1.0 : 0.75)
                                .lineLimit(1)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
        }
    }
}

// MARK: - Widget declaration

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

struct TrueNorthWidget: Widget {
    let kind: String = "TrueNorthWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            TrueNorthWidgetEntryView(entry: entry)
                .containerBackground(.northBackground, for: .widget)
                .modelContainer(SharedModel.container)
        }
        .contentMarginsDisabled()
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge, .accessoryRectangular,
        ])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }

    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    TrueNorthWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, goals: [])
    SimpleEntry(date: .now, configuration: .starEyes, goals: [])
}
