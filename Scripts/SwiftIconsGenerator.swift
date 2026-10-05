//
//  SwiftIcons.swift
//  SwiftIcons
//
//  Created by Tye Porter on 10/3/26.
//

import Foundation

enum SwiftIconSystem: String, Codable {
	case lucide = "Lucide"
	case bootstrap = "Bootstrap"
	case fontAwesome = "FontAwesome"
	case fontAwesomeBrand = "FontAwesome Brand"
	case fontAwesomeFilled = "FontAwesome Filled"
	case phosphor = "Phosphor"
	case phosphorThin = "Phosphor Thin"
	case phosphorLight = "Phosphor Light"
	case phosphorBold = "Phosphor Bold"
	case phosphorDuotone = "Phosphor Duotone"
	case tabler = "Tabler"
	case tablerFilled = "Tabler Filled"
	case feather = "Feather"
	case heroicons = "Heroicons"
	case heroiconsFilled = "Heroicons Filled"

    var colorFileName: String {
        "Icon+\(self.rawValue.replacingOccurrences(of: " ", with: "")).swift"
    }
}

struct SwiftIconLibrary: Codable {
    let system: SwiftIconSystem
	let version: Double
    let prefix: String
    let folderName: String
}

@main
struct SwiftIconsGenerator {
	static let PROJECT_ROOT_DIRECTORY = FileManager.default.currentDirectoryPath
	static let RESOURCES_DIRECTORY = "\(PROJECT_ROOT_DIRECTORY)/Resources"
	static let SOURCES_DIRECTORY = "\(PROJECT_ROOT_DIRECTORY)/Sources/SwiftIcons"
    static let INPUT_FILE_NAME = "Icons.json"

    static func toPascalCase(_ string: String) -> String {
        string.components(separatedBy: CharacterSet(charactersIn: "-_"))
            .map { $0.capitalized }
            .joined()
    }

	static func sanitizeAndEscapeSVG(_ rawSvg: String) -> String {
		var svg = rawSvg.replacingOccurrences(of: "<rect[^>]*fill=\"none\"[^>]*>", with: "", options: .regularExpression)

		svg = svg.replacingOccurrences(of: "#000000", with: "currentColor")
		svg = svg.replacingOccurrences(of: "#000", with: "currentColor")

		svg = svg.replacingOccurrences(of: "\n", with: "")
		svg = svg.replacingOccurrences(of: "\r", with: "")
		svg = svg.replacingOccurrences(of: "\"", with: "\\\"")

		return svg
	}

	static func generateSystemFiles() throws {
		let fileManager = FileManager.default
		let iconsFile = URL(fileURLWithPath: RESOURCES_DIRECTORY)
			.appendingPathComponent(INPUT_FILE_NAME)

		let fileData = try Data(contentsOf: iconsFile)
		let decoder = JSONDecoder()
		decoder.allowsJSON5 = true
		let systems = try decoder.decode([SwiftIconLibrary].self, from: fileData)

		for system in systems {
			let safeSystemName = system.system.rawValue.replacingOccurrences(of: " ", with: "")
			let systemPath = URL(fileURLWithPath: RESOURCES_DIRECTORY)
				.appendingPathComponent(system.folderName).path

			guard fileManager.fileExists(atPath: systemPath) else {
				print("⚠️ Invalid directory: \(systemPath). Skipping ...")
				continue
			}

			let files = try fileManager.contentsOfDirectory(atPath: systemPath)
			let svgFiles = files.filter { $0.hasSuffix(".svg") }.sorted()

			var generatedExtensions = ""
			var successGenerations = 0

			for fileName in svgFiles {
				let iconName = fileName.replacingOccurrences(of: ".svg", with: "")
				let sourcePath = URL(fileURLWithPath: systemPath)
					.appendingPathComponent(fileName).path

				do {
					let rawSvgString = try String(contentsOfFile: sourcePath, encoding: .utf8)

					let safeSvg = sanitizeAndEscapeSVG(rawSvgString)
					let pascalName = toPascalCase(iconName)
					let propertyName = "\(system.prefix)\(pascalName)"

					generatedExtensions += """
						/// An icon descriptor that represents the `\(iconName)` icon from \(system.system.rawValue) (v\(system.version)).
						static var \(propertyName): \(safeSystemName)IconDescriptor {
							\(safeSystemName)IconDescriptor(
								name: "\(iconName)",
								rawSVG: "\(safeSvg)",
							)
						}

					"""
					successGenerations += 1
				} catch {
					print("❌ Failed to process \(fileName): \(error.localizedDescription)")
				}
			}

			let fileContent = """
			//
			// AUTO-GENERATED FILE - THIS FILE IS NOT MEANT TO BE EDITED MANUALLY
			// PLEASE SEE `README.md` FOR INFORMATION ON HOW TO UPDATE ICONS
			//

			import Foundation

			public struct \(safeSystemName)IconDescriptor: SwiftIconDescriptor {
				public let name: String
				public let rawSVG: String

				public init(name: String, rawSVG: String) {
					self.name = name
					self.rawSVG = rawSVG
				}
			}

			public extension SwiftIconDescriptor where Self == \(safeSystemName)IconDescriptor {
			\(generatedExtensions)}
			"""

            let outputPath = "\(SOURCES_DIRECTORY)/\(system.system.colorFileName)"
			try fileContent.write(toFile: outputPath, atomically: true, encoding: .utf8)
			print("👍 Generated \(successGenerations) icons for \(system.system.rawValue) ...")
		}

		print("✅ Successfully generated icon files.")
	}

	static func main() {
		do {
			try generateSystemFiles()
		} catch {
			print("❌ There was an error: \(error.localizedDescription)")
		}
	}
}
