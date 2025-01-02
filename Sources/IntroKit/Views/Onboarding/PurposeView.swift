//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 5/21/23.
//

import SwiftUI
import CoreHaptics

/// A reusable and extensible view with animated text input and typing effect
public struct PurposeView<IconView: View, TitleView: View, CTAView: View>: View {
    @State private var letters: [Letter] = []
    @State private var sentence: String = ""
    @State private var randomValue: Double = 0
    @StateObject private var engine = HapticManager.shared
    @FocusState private var textFieldSelected: Bool

    let iconView: IconView
    let titleView: TitleView
    let ctaView: CTAView
    let introText: [String]
    let placeholder: String
    let onSubmit: (String) -> Void

    var showsTextField: Bool = true
    var usesHaptics: Bool = true

    public init(
        iconView: IconView,
        titleView: TitleView,
        ctaView: CTAView,
        introText: [String],
        placeholder: String = "",
        showsTextField: Bool = true,
        usesHaptics: Bool = true,
        onSubmit: @escaping (String) -> Void
    ) {
        self.iconView = iconView
        self.titleView = titleView
        self.ctaView = ctaView
        self.introText = introText
        self.placeholder = placeholder
        self.showsTextField = showsTextField
        self.usesHaptics = usesHaptics
        self.onSubmit = onSubmit
    }

    public var body: some View {
        VStack(alignment: .leading) {
            iconView.padding(.bottom)
            titleView.padding(.vertical)

            ZStack {
                if showsTextField {
                    TextField(placeholder, text: $sentence)
                        .font(.largeTitle.bold())
                        .focused($textFieldSelected)
                        .opacity(0.01) // Hide textfield for animation effect
                        .onChange(of: sentence) { _ in
                            Task { await handleTypingEffect() }
                        }
                }

                HStack(spacing: 1) {
                    ForEach(letters + [Letter(" ")]) { letter in
                        Text(String(letter.char))
                            .font(.largeTitle.bold())
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.accentColor, .accentColor.opacity(0.5)],
                                    startPoint: .leading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    Spacer()
                }
            }

            if !sentence.isEmpty {
                ctaView
                    .onTapGesture {
                        onSubmit(sentence)
                        sentence = ""
                        letters = []
                        generateRandomHaptic()
                    }
                    .buttonStyle(.borderedProminent)
                    .transition(.opacity)
            }
        }
        .padding()
        .task {
            engine.prepareHaptics()
            await displayIntroText()
        }
    }

    private func handleTypingEffect() async {
        letters = sentence.map { Letter(String($0)) }
        generateRandomHaptic()
    }

    private func displayIntroText() async {
        for text in introText {
            await showTextAnimation(text)
        }
        textFieldSelected = true
    }

    private func showTextAnimation(_ text: String) async {
        letters = []
        let characters = text.map { Letter(String($0)) }
        for character in characters {
            try? await Task.sleep(for: .seconds(0.1))
            withAnimation {
                letters.append(character)
            }
            generateRandomHaptic()
        }
        
        try? await Task.sleep(for: .seconds(0.5))
    }

    private func generateRandomHaptic() {
        let oldValue = randomValue
        randomValue = Double.random(in: 0...100)
        let amount = abs(oldValue - randomValue) / 100.0
        if usesHaptics {
            engine.generateHaptic(flexibility: .hapticSharpness, intensity: Float(amount))
        }
    }
}

public struct Letter: Identifiable {
    public let id = UUID()
    public let char: String

    public init(_ char: String) {
        self.char = char
    }
}

// MARK: - Preview
#Preview {
    PurposeView(
        iconView: Image(systemName: "figure.walk").foregroundStyle(Color.accentColor).font(.largeTitle),
        titleView: Text("I walk to...")
            .font(.headline)
            .foregroundStyle(.blue),
        ctaView: Button("Next") { },
        introText: ["Live healthier", "Think clearer", "Dream deeper", "Feel happier"],
        placeholder: "Type here...",
        onSubmit: { print($0) }
    )
}
