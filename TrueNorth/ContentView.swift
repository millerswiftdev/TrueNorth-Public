//
//  TrueNorthApp.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/3/26.
//

import ParallaxSwiftUI
import SDWebImageSwiftUI
import SwiftData
import SwiftUI
import WidgetKit
import RevenueCat

@main
struct TrueNorthApp: App {
    @AppStorage("showWelcome") private var showWelcome: Bool = true
    @State private var entitlements = EntitlementStore()

    let container: ModelContainer

    init() {
        Purchases.configure(withAPIKey: "test_aSwIYiyYgeAdNAouTItGxhHOECJ")
        do {
            container = try ModelContainer(for: Goal.self, Wolf.self)

            let context = ModelContext(container)
            let descriptor = FetchDescriptor<Wolf>()
            let existingCount = try context.fetchCount(descriptor)

            // If empty, create the first-launch object
            if existingCount == 0 {
                let firstItem = Wolf()
                context.insert(firstItem)
                try context.save()
            }
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(entitlements)
                .task { await entitlements.checkEntitlement() }
                .sheet(isPresented: $showWelcome) {
                    WelcomeView(isShowingSheet: $showWelcome)
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
        }
        .modelContainer(container)
    }
}

struct ContentView: View {

    @State private var animation: WolfAnimation = .walk
    private let barkDuration: TimeInterval = 1

    @State private var hapticsTrigger = 0
    @Environment(\.modelContext) private var context
    @State private var isShowingSettings = false
    @State private var showZZZ = false

    @Query(filter: #Predicate<Goal> { $0.isCurrentGoal }, sort: \Goal.order)
    private var currentGoals: [Goal]

    @Query(filter: #Predicate<Goal> { !$0.isCurrentGoal }, sort: \Goal.order)
    private var backlog: [Goal]

    @State private var draggingID: UUID?

    // Alert State Variables
    @State private var showingAddAlert = false
    @State private var newGoalText = ""
    let demoGoal: Goal = Goal(text: "", order: 0, isCurrentGoal: true)

    @State private var isAddPresented = false
    @State private var isEditPresented = false
    @State private var editText = ""
    @State private var editingGoal: Goal?

    @State var animateMountains = true

    var body: some View {
        NavigationStack {
            ZStack {

                VStack {
                    ZStack {
                        StarCanvasView()
                            .scaleEffect(1.4, anchor: .bottom)
                            .parallax(amount: 90, direction: .both)
                            .frame(maxWidth: .infinity)
                            .offset(x: 0, y: -50)
                            .background(Color.northBackground)

                            .ignoresSafeArea(.all)

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                VStack {
                                    ScrollingMountainsView(
                                        animate: $animateMountains
                                    )
                                    .frame(height: 140)
                                    .padding(.bottom, -10)
                                    Color.groundTransistion
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, -40)
                                        .frame(height: 40)
                                        .ignoresSafeArea()
                                }
                                .parallax(amount: 20, direction: .both)
                                .padding(.top, 200)

                            }

                        }

                        if isAddPresented {
                            ZStack {
                                VStack {}
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity
                                    )
                                    .glassEffect(
                                        .regular.tint(
                                            .groundTransistion.opacity(0.4)
                                        ),
                                        in: .rect(corners: .concentric)
                                    )

                                    .padding(.top, 3)
                                    .padding(.horizontal, 3)
                                    .ignoresSafeArea()

                                VStack {
                                    VStack {
                                        Text("Enter Your Goal")
                                            .font(.title2)
                                            .bold()
                                            .padding()
                                        Text(
                                            "What is a north you want now or in your future?"
                                        )
                                        .font(.headline)
                                        .padding()
                                        .multilineTextAlignment(.center)

                                        ConstructionGoalCard(
                                            newGoalText: $newGoalText
                                        )

                                        Button("Add") {
                                            if !newGoalText.isEmpty {
                                                UIApplication.shared.sendAction(
                                                    #selector(
                                                        UIResponder
                                                            .resignFirstResponder
                                                    ),
                                                    to: nil,
                                                    from: nil,
                                                    for: nil
                                                )
                                                let generator =
                                                    UIImpactFeedbackGenerator(
                                                        style: .medium
                                                    )
                                                generator.impactOccurred()

                                                withAnimation(.easeInOut) {
                                                    addNewGoal()
                                                    newGoalText = ""
                                                    isAddPresented = false
                                                }
                                                withAnimation(
                                                    .linear(duration: 500)
                                                        .repeatForever(
                                                            autoreverses: false
                                                        )
                                                ) {
                                                    animateMountains = true
                                                }
                                            } else {
                                                let generator =
                                                    UIImpactFeedbackGenerator(
                                                        style: .rigid
                                                    )
                                                generator.impactOccurred()
                                            }
                                        }
                                        .buttonStyle(.glass)

                                        Spacer()

                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }

                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                        }

                        if isEditPresented {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    WolfSpriteView(animation: .howl)
                                        .transaction {
                                            $0.disablesAnimations = true
                                        }
                                }
                            }
                            .allowsHitTesting(false)
                            .zIndex(2)
                        }

                        if isEditPresented {
                            ZStack {
                                VStack {}
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: .infinity
                                    )
                                    .glassEffect(
                                        .regular.tint(
                                            .groundTransistion.opacity(0.4)
                                        ),
                                        in: .rect(corners: .concentric)
                                    )

                                    .padding(.top, 3)
                                    .padding(.horizontal, 3)
                                    .ignoresSafeArea()

                                VStack {
                                    VStack {
                                        Text("Edit Your Goal")
                                            .font(.title2)
                                            .bold()
                                            .padding()

                                        ConstructionGoalCard(
                                            newGoalText: $editText
                                        )

                                        Button("Save") {
                                            if !editText.trimmingCharacters(
                                                in: .whitespacesAndNewlines
                                            ).isEmpty {
                                                UIApplication.shared.sendAction(
                                                    #selector(
                                                        UIResponder
                                                            .resignFirstResponder
                                                    ),
                                                    to: nil,
                                                    from: nil,
                                                    for: nil
                                                )
                                                let generator =
                                                    UIImpactFeedbackGenerator(
                                                        style: .medium
                                                    )
                                                generator.impactOccurred()

                                                withAnimation(.easeInOut) {
                                                    saveEditedGoal()
                                                    isEditPresented = false
                                                }
                                                withAnimation(
                                                    .linear(duration: 500)
                                                        .repeatForever(
                                                            autoreverses: false
                                                        )
                                                ) {
                                                    animateMountains = true
                                                }
                                            } else {
                                                let generator =
                                                    UIImpactFeedbackGenerator(
                                                        style: .rigid
                                                    )
                                                generator.impactOccurred()
                                            }
                                        }
                                        .buttonStyle(.glass)

                                        Spacer()

                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .padding(.top, 100)
                            }

                            .transition(.move(edge: .bottom))
                            .zIndex(1)
                        }

                        if isAddPresented {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    WolfSpriteView(animation: .howl)
                                        .transaction {
                                            $0.disablesAnimations = true
                                        }
                                }
                            }
                            .allowsHitTesting(false)
                            .zIndex(2)
                        }

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()

                                if currentGoals.count == 0 {
                                    ZStack {
                                        WolfSpriteView(animation: .sleep)

                                        if showZZZ {
                                            Image(systemName: "zzz")
                                                .frame(width: 40)
                                                .offset(x: 29, y: 25)
                                                .foregroundStyle(.background)
                                                .symbolEffect(.breathe)
                                                .transition(.opacity)  // Optional transition
                                                .onDisappear {
                                                    showZZZ = false
                                                }
                                        }
                                    }
                                    .task {
                                        withAnimation {
                                            animateMountains = false
                                        }
                                        // Delay for 1 second (1,000,000,000 nanoseconds or 1 second duration)
                                        try? await Task.sleep(
                                            for: .seconds(1.5)
                                        )
                                        withAnimation {
                                            showZZZ = true
                                        }
                                    }
                                } else {
                                    if isAddPresented {

                                    } else {
                                        WolfSpriteView(animation: animation)
                                            .transaction {
                                                $0.disablesAnimations = true
                                            }
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                print("Poked wolf")
                                                guard animation != .growl else {
                                                    return
                                                }
                                                animateMountains = false
                                                animation = .growl
                                                DispatchQueue.main.asyncAfter(
                                                    deadline: .now()
                                                        + barkDuration
                                                ) {
                                                    animation = .walk
                                                    animateMountains = true
                                                }
                                            }
                                            .task {
                                                withAnimation {
                                                    animateMountains = true
                                                }
                                            }
                                    }
                                }

                            }
                        }
                        //.parallax(amount: 20, direction: .both)
                        .padding(.bottom, 10)

                        VStack(alignment: .center, spacing: 24) {
                            Text("My True North")
                                .font(.title)
                                .bold()
                            ZStack {
                                VStack(spacing: 8) {
                                    ForEach(0..<3, id: \.self) { index in
                                        DemoGoalCard(
                                            goal: demoGoal,
                                            isCurrentEmpty: index
                                                == currentGoals.count
                                        )
                                        .id(index)
                                    }
                                    Spacer()
                                }
                                .animation(
                                    .spring(
                                        response: 0.4,
                                        dampingFraction: 0.75
                                    ),
                                    value: currentGoals.count
                                )
                                VStack(spacing: 8) {
                                    ForEach(currentGoals) { goal in
                                        row(for: goal, isCurrent: true)
                                            .dropDestination(
                                                for: GoalTransfer.self
                                            ) { items, _ in
                                                guard let item = items.first
                                                else { return false }
                                                let alreadyCurrent =
                                                    currentGoals.contains {
                                                        $0.id == item.id
                                                    }
                                                guard
                                                    alreadyCurrent
                                                        || currentGoals.count
                                                            < 3
                                                else { return false }
                                                return handleDrop(
                                                    items,
                                                    targeting: goal,
                                                    isCurrent: true
                                                )
                                            }
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .dropDestination(for: GoalTransfer.self) { items, _ in
                            // Prevent dropping if already at or over 3 items
                            guard currentGoals.count < 3 else { return false }

                            return handleDrop(
                                items,
                                targeting: nil,
                                isCurrent: true
                            )
                        }
                        .padding(.vertical)

                    }
                    .frame(maxWidth: .infinity, maxHeight: 500)

                    VStack(spacing: 0) {
                        ZStack {
                            dropZone(isCurrent: false, targetList: backlog)  // restore this

                            ScrollView {
                                VStack(spacing: 8) {
                                    ForEach(backlog) { goal in
                                        row(for: goal, isCurrent: false)
                                            .dropDestination(
                                                for: GoalTransfer.self
                                            ) { items, _ in
                                                handleDrop(
                                                    items,
                                                    targeting: goal,
                                                    isCurrent: false
                                                )
                                            }
                                    }
                                }
                            }
                            .safeAreaInset(edge: .top, spacing: 10) {
                                HStack {
                                    Text("Some Day").font(.title2).bold()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .glassEffect(
                                    .regular.tint(
                                        Color.groundTransistion.opacity(0.4)
                                    ),
                                    in: .rect(cornerRadius: 0)
                                )
                            }
                        }
                        Spacer()
                    }

                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    .background(Color.northBrown)
                    .ignoresSafeArea(edges: .bottom)
                    .dropDestination(for: GoalTransfer.self) { items, _ in
                        // Prevent dropping if already at or over 3 items

                        return handleDrop(
                            items,
                            targeting: nil,
                            isCurrent: false
                        )
                    }

                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if isAddPresented {
                            Button(action: {
                                UIApplication.shared.sendAction(
                                    #selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil
                                )
                                let generator = UIImpactFeedbackGenerator(
                                    style: .medium
                                )
                                generator.impactOccurred()

                                withAnimation(.easeInOut) {
                                    isAddPresented.toggle()

                                }
                                withAnimation(
                                    .linear(duration: 500).repeatForever(
                                        autoreverses: false
                                    )
                                ) {
                                    animateMountains = true
                                }
                            }) {
                                Text("Done")
                            }
                            .sensoryFeedback(
                                .selection,
                                trigger: isAddPresented
                            )
                        } else if isEditPresented {
                            Button(action: {
                                UIApplication.shared.sendAction(
                                    #selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil
                                )
                                let generator = UIImpactFeedbackGenerator(
                                    style: .medium
                                )
                                generator.impactOccurred()

                                withAnimation(.easeInOut) {
                                    isEditPresented.toggle()

                                }
                                withAnimation(
                                    .linear(duration: 500).repeatForever(
                                        autoreverses: false
                                    )
                                ) {
                                    animateMountains = true
                                }
                            }) {
                                Text("Done")
                            }
                            .sensoryFeedback(
                                .selection,
                                trigger: isAddPresented
                            )
                        } else {
                            Button(action: {

                                let generator = UIImpactFeedbackGenerator(
                                    style: .medium
                                )
                                generator.impactOccurred()

                                withAnimation(.easeInOut) {
                                    isAddPresented.toggle()
                                    animateMountains = false
                                }
                            }) {
                                Label("Add", systemImage: "plus")
                            }
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isShowingSettings.toggle()
                        }) {
                            Label("Settings", systemImage: "gear")
                        }
                        .sensoryFeedback(.selection, trigger: isShowingSettings)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(
                .linear(duration: 500).repeatForever(autoreverses: false)
            ) {
                animateMountains = true
            }
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
        }
    }

    private func saveEditedGoal() {
        guard let goal = editingGoal else { return }
        let trimmedText = editText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        goal.text = trimmedText.isEmpty ? goal.text : trimmedText
        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
        editingGoal = nil
    }

    private func addNewGoal() {
        let trimmedText = newGoalText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        let finalText = trimmedText.isEmpty ? "New Goal" : trimmedText

        // Push every existing backlog item down one to make room at the top.
        for g in backlog {
            g.order += 1
        }

        let newGoal = Goal(text: finalText, order: 0, isCurrentGoal: false)
        context.insert(newGoal)

        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }

    @ViewBuilder
    private func row(for goal: Goal, isCurrent: Bool) -> some View {
        GoalCard(goal: goal, isDragging: draggingID == goal.id)
            .draggable(
                GoalTransfer(id: goal.id),
                preview: {
                    GoalDragCard(goal: goal)
                        .frame(width: UIScreen.main.bounds.width - 32)  // match your actual row width/padding
                        .background(.clear)  // whatever GoalCard's real background color/material is
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .compositingGroup()
                        .contentShape(
                            .dragPreview,
                            RoundedRectangle(cornerRadius: 16)
                        )
                        .onAppear { draggingID = goal.id }
                }
            )
            .contextMenu {
                Button {
                    animateMountains = false
                    hapticsTrigger += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        editingGoal = goal
                        editText = goal.text
                        withAnimation(.easeInOut) {
                            isEditPresented = true
                        }
                    }
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
                .sensoryFeedback(.stop, trigger: hapticsTrigger)
                Button(role: .destructive) {
                    deleteGoal(goal)
                    hapticsTrigger += 1
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .sensoryFeedback(.stop, trigger: hapticsTrigger)
            }
    }

    @ViewBuilder
    private func dropZone(isCurrent: Bool, targetList: [Goal]) -> some View {
        Color.clear
            .frame(width: 200, height: 200)
            .dropDestination(for: GoalTransfer.self) { items, _ in
                handleDrop(items, targeting: nil, isCurrent: isCurrent)
            }
    }

    private func handleDrop(
        _ items: [GoalTransfer],
        targeting target: Goal?,
        isCurrent: Bool
    ) -> Bool {
        guard let item = items.first else { return false }
        let descriptor = FetchDescriptor<Goal>(
            predicate: #Predicate { $0.id == item.id }
        )
        guard let draggedGoal = try? context.fetch(descriptor).first else {
            return false
        }

        defer { draggingID = nil }

        let wasCurrent = draggedGoal.isCurrentGoal
        let destinationList = isCurrent ? currentGoals : backlog

        if wasCurrent == isCurrent,
            let target, target.id != draggedGoal.id,
            let originalDraggedIndex = destinationList.firstIndex(where: {
                $0.id == draggedGoal.id
            }),
            let originalTargetIndex = destinationList.firstIndex(where: {
                $0.id == target.id
            })
        {

            // Reordering within the same list — cascade everything between
            // the old and new spot by one.
            var list = destinationList
            list.remove(at: originalDraggedIndex)

            let movingForward = originalDraggedIndex < originalTargetIndex
            let filteredTargetIndex =
                movingForward ? originalTargetIndex - 1 : originalTargetIndex
            let insertIndex =
                movingForward ? filteredTargetIndex + 1 : filteredTargetIndex

            list.insert(draggedGoal, at: insertIndex)

            for (index, g) in list.enumerated() {
                g.order = index
            }
        } else {
            // Crossing between current <-> backlog
            draggedGoal.isCurrentGoal = isCurrent
            var list = destinationList.filter { $0.id != draggedGoal.id }
            if let target,
                let targetIndex = list.firstIndex(where: { $0.id == target.id })
            {
                list.insert(draggedGoal, at: targetIndex)
            } else {
                list.append(draggedGoal)
            }
            for (index, g) in list.enumerated() {
                g.order = index
            }
        }

        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
        return true
    }

    private func deleteGoal(_ goal: Goal) {
        let wasCurrent = goal.isCurrentGoal
        context.delete(goal)

        let remaining = (wasCurrent ? currentGoals : backlog).filter {
            $0.id != goal.id
        }
        for (index, g) in remaining.enumerated() {
            if wasCurrent { g.order = index } else { g.order = index }
        }

        try? context.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
}
