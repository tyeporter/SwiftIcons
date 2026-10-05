// swift-tools-version: 5.9
import PackageDescription

let package = Package(
	name: "SwiftIcons",
	platforms: [
		.iOS(.v15),
		.macOS(.v13),
		.tvOS(.v15),
		.watchOS(.v9),
		.visionOS(.v1)
	],
	products: [
		.library(
			name: "SwiftIcons",
			targets: ["SwiftIcons"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/exyte/SVGView.git", from: "1.0.6")
	],
	targets: [
		.target(
			name: "SwiftIcons",
			dependencies: [.product(name: "SVGView", package: "SVGView")]
		),
		.executableTarget(
			name: "SwiftIconsGenerator",
			path: "Scripts"
		)
	]
)
