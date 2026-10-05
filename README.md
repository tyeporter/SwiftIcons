# SwiftIcons 💟

A vector icon toolkit that brings popular open-source design system icons to Apple Platforms (iOS, macOS, watchOS, tvOS, and visionOS).

> [!IMPORTANT]
> SwiftIcons is currently in beta and under active development. While fully functional for prototyping, you may want to wait to use it in production. See [Beta Notice & Limitations](#beta-notice--limitations).

## Supported Libraries

- Bootstrap
- Feather
- FontAwesome
- Heroicons
- Lucide
- Phosphor
- Tabler

## Installation

### Xcode

To add `SwiftColors` to an existing Xcode project:
1. Go to **File > Add Package Dependencies...**
2. Paste the repository URL: `https://github.com/tyeporter/SwiftIcons.git`
3. Select **Up to Next Major Version** and select your project as the target.

### Swift Package Manager

For installation with Swift Package Manager, simply add the following to your `Package.swift`:

```
.package(url: "https://github.com/tyeporter/SwiftIcons.git", from: "0.1.0")
```

## Usage

Icon descriptors are prefixed by their respective library (e.g., `bs..` for Bootstrap, `fa..` for FontAwesome, etc.).

To use icons in your project, `SwiftIcons` provides a `SwiftIcon` `View` that takes a `SwiftIconDescriptor` and an optional `size` argument:

```swift
import SwiftUI
import SwiftIcons

struct ContentView: View {
	var body: some View {
		VStack {
			SwiftIcon(.tbBrandApple, size: 100)
				.foregroundStyle(.linearGradient(
					colors: [.blue, .purple],
					startPoint: .topLeading,
					endPoint: .bottomTrailing
				))
		}
		.padding()
	}
}
```

## Beta Notice & Limitations

This package is currently in Beta, and was quickly built for a course I'm working on. In its current state, it doesn't support dynamic styling for things like stroke widths. As a workaround, some of the provided icons have bold and fill variants.

## Contributing

`SwiftIcons` uses a generator script (`Scripts/SwiftIconsGenerator.swift`) to build the Swift extensions that provide the icon tokens.

To add new icons or update existing libraries:

1. Copy the raw SVG files into their respective directory under `Resources`
2. Run the generator script from the root directory using `make`:
```bash
make generate
```

## Acknowledgements

Thanks to the folks at Exyte, **SwiftIcons** was quickly built on top of [SVGView](https://github.com/exyte/SVGView).

## License

[MIT License](LICENSE)
