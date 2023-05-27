//
//  SwiftUIView.swift
//  
//
//  Created by Andreas Ink on 5/21/23.
//

import SwiftUI
import CoreHaptics

public struct PurposeView: View {
    @EnvironmentObject var vm: IntroViewModel
    @State var letters = [Letter]()
    @State var sentence = ""
    @StateObject private var engine = HapticManager.shared
    @FocusState var textFieldSelected: Bool
    /// Text that is typed by app, animates as it's typed
    let introText: [String]
    /// The call to action button's title
    let cta: String
    var isOnboarding = true
    var isPlain = false
    var input = ""
    public init(introText: [String], cta: String, isOnboarding: Bool = true, isPlain: Bool = false, input: String = "") {
        self.introText = introText
        self.cta = cta
        self.isOnboarding = isOnboarding
        self.isPlain = isPlain
        self.input = input
    }
    public var body: some View {
        VStack(alignment: .leading) {
            if isOnboarding {
                Image(systemName: "figure.walk")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
            }
            if !isPlain {
                Text("I walk to..")
                    .font(.headline)
                    .padding(.vertical)
            }
            ZStack {
                if !isPlain {
                    TextField("", text: $sentence)
                        .foregroundColor(.clear)
                        .font(.largeTitle.bold())
                        .focused($textFieldSelected)
                        .onChange(of: sentence) { newValue in
                            Task {
                                if newValue.count == 1 || newValue.count == 0  {
                                    letters = []
                                }
                                if let last = newValue.last {
                                    await showText(String(last))
                                }
                                vm.reason = sentence
                            }
                        }
                }
                HStack(spacing: 1) {
                    ForEach(letters + [Letter(" ")]) { letter in
                        Text(String(letter.char))
                            .font(.largeTitle.bold())
                            .foregroundStyle(LinearGradient(colors: [.accentColor, .accentColor.opacity(0.5)], startPoint: .leading, endPoint: .bottomTrailing))
                        
                    }
                    Spacer()
                }
            }
            if isOnboarding && sentence.count > 3 {
                Button {
                    vm.onboardingIndex += 1
                } label: {
                    Label {
                        Text(cta)
                    } icon: {
                        Image(systemName: "figure.walk.departure")
                    }
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .transition(.opacity)

            }
        }
        .task {
            
            engine.prepareHaptics()
            if isOnboarding {
                for text in introText {
                    await showText(text)
                }
                try? await Task.sleep(for: .seconds(1))
                if isOnboarding {
                    letters = []
                    textFieldSelected = true
                }
            } else if isPlain {
                await showText(input)
            } else {
                await showText(vm.reason)
            }
        }
        .padding(.horizontal)
    }
    func showText(_ sentence: String) async {
        if self.sentence.isEmpty {
            try? await Task.sleep(for: .seconds(1))
            letters = []
        }
        let newSentence = sentence.map {String($0)}
        for charIndex in newSentence.indices {

            try? await Task.sleep(for: .seconds(Double(charIndex) * 0.01))
            withAnimation(IntroAnimations.plopp) {
                letters.append(Letter(newSentence[charIndex]))
            }
            if !isOnboarding && vm.showOnboarding {
                engine.complexSuccess()
            }
        }
    }
}

public struct PurposeView_Previews: PreviewProvider {
    public static var previews: some View {
        PurposeView(introText: ["Live healthier", "Think clearer", "Dream deeper", "Feel happier"], cta: "Next")
    }
}
public struct Letter: Identifiable {
    public init(_ char: String) {
        self.char = char
    }
    public var id = UUID()
    public let char: String
}
