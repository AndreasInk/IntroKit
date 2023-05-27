//
//  IntroViewModel.swift
//  
//
//  Created by Andreas Ink on 5/21/23.
//

import SwiftUI

public class IntroViewModel: HapticManager {
    @Published var onboardingIndex = 0
    @AppStorage("reason") var reason = ""
    @AppStorage("showOnboarding") var showOnboarding = true
}
