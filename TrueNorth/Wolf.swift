//
//  Wolf.swift
//  TrueNorth
//
//  Created by Jack Miller on 9/8/26.
//

import Foundation
import SwiftData
import WidgetKit

@Model
final class Wolf: Identifiable {
    var id: UUID = UUID()
    var colorChoice: Wolf.ColorChoice = Wolf.ColorChoice.grey

    init(id: UUID = UUID(), colorChoice: ColorChoice = .grey) {
        self.id = id
        self.colorChoice = colorChoice
    }

    @discardableResult
    func setChoice(_ newChoice: ColorChoice, isUserPremium: Bool) -> Bool {
        if newChoice.isPremium && !isUserPremium {
            print("Color not set, user is not premium")
            return false
        }
        self.colorChoice = newChoice
        WidgetCenter.shared.reloadAllTimelines()
        print("Color set")
        return true
    }
}

extension Wolf {
    enum ColorChoice: String, Codable, CaseIterable, Identifiable {
        case grey
        case brown

        case sage
        case aqua
        case gold
        case fire
        case metal

        var id: String { rawValue }

        var displayName: String {
            rawValue.capitalized
        }
        var swiftName: String {
            rawValue
        }

        var isPremium: Bool {
            switch self {
            case .grey, .brown:
                return false
            case .sage, .aqua, .gold, .fire, .metal:
                return true
            }
        }
    }
}
