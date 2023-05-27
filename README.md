# IntroKit

[![SwiftUI](https://img.shields.io/badge/-SwiftUI-ff69b4)](https://developer.apple.com/documentation/swiftui)
[![iOS 16](https://img.shields.io/badge/-iOS%2016-blue)](https://developer.apple.com/ios/)

IntroKit is a powerful and highly customizable SwiftUI framework designed to enhance the onboarding experience of your iOS applications. Inspired by the interactive onboarding experience of ChatGPT iOS, IntroKit enables developers to effortlessly deliver clear and engaging onboarding to their users, showcasing the key features and benefits of using their app.

![IntroKit](https://github.com/AndreasInk/IntroKit/assets/67549402/6dad9a9c-25c7-4d21-a160-2f799f42c099)

## Features

- Dynamic typing animation to focus on benifits of your app
- Customizable text and call-to-action button
- Adaptive for onboarding and plain states
- Core Haptics integration
- Utilizes SwiftUI's newest and most powerful features

## Installation

You can add IntroKit to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter the following URL: https://github.com/AndreasInk/IntroKit.git
3. Click **Next**. Specify the version details, then click **Next** again to add the package to your project.

## Usage

```swift
import SwiftUI
import IntroKit

struct ContentView: View {
    var body: some View {
        PurposeView(introText: ["Live healthier", "Think clearer", "Dream deeper", "Feel happier"], cta: "Next")
    }
}
```

In this example, `PurposeView` is used to generate an onboarding screen with the provided `introText` and call-to-action button text `cta`.

## Contributing

Contributions to IntroKit are welcome and greatly appreciated! Please feel free to create a pull request or open an issue on this GitHub repository.

## License

IntroKit is available under the MIT license. See the [LICENSE](https://github.com/YourGitHubUsername/IntroKit/LICENSE) file for more info. 

---
Built with ❤️ using SwiftUI.
