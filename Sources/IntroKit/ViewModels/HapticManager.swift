//
//  HapticManager.swift
//  
//
//  Created by Andreas Ink on 5/21/23.
//

import SwiftUI
import CoreHaptics

// https://www.hackingwithswift.com/books/ios-swiftui/making-vibrations-with-uinotificationfeedbackgenerator-and-core-haptics
/// Handles haptics with dynamic intensity support
public class HapticManager: ObservableObject {
    public static let shared = HapticManager()
    @Published private var engine: CHHapticEngine?

    public func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error creating the engine: \(error.localizedDescription)")
        }
    }

    /// Generate a haptic feedback based on given flexibility and intensity
    public func generateHaptic(flexibility: CHHapticEvent.ParameterID, intensity: Float) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: flexibility, value: intensity)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParam, sharpnessParam], relativeTime: 0)
        events.append(event)

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic pattern: \(error.localizedDescription)")
        }
    }
}
