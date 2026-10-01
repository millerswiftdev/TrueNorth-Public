//
//  Goal.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/3/26.
//

import CoreTransferable
import Foundation
import SwiftData
import UniformTypeIdentifiers

@Model
final class Goal {
    var id: UUID
    var text: String
    var order: Int
    var isCurrentGoal: Bool

    init(text: String, order: Int, isCurrentGoal: Bool) {
        self.text = text
        self.order = order
        self.isCurrentGoal = isCurrentGoal
        self.id = UUID()
    }
}

struct GoalTransfer: Codable, Transferable {
    let id: UUID

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .goalTransfer)
    }
}

extension UTType {
    static let goalTransfer = UTType(
        exportedAs: "com.jackmiller.truenorth.goaltransfer"
    )
}
