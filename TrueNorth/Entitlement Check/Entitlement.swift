//
//  Entitlement.swift
//  TrueNorth
//
//  Created by Jack Miller on 10/1/26.
//

import SwiftUI
import RevenueCat

@MainActor
@Observable
final class EntitlementStore {
    var isPremium = false

    func checkEntitlement() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            isPremium = customerInfo.entitlements["true_north_pro"]?.isActive == true
        } catch {
            print("Error: \(error)")
        }
    }
}
