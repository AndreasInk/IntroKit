//
//  IntroViewModel.swift
//  
//
//  Created by Andreas Ink on 5/21/23.
//

import SwiftUI

/// Handles any persistant or cross view vars
public class IntroViewModel: HapticManager {
    public override init() {
        
    }
    @Published var onboardingIndex = 0
    @AppStorage("reason") var reason = ""
    @AppStorage("showOnboarding") var showOnboarding = true
}
