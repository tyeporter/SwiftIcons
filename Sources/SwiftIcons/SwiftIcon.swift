//
//  SwiftIcon.swift
//  SwiftIcon
//
//  Created by Tye Porter on 10/3/26.
//

import SVGView
import SwiftUI

public protocol SwiftIconDescriptor {
	var name: String { get }
	var rawSVG: String { get }
}

public struct SwiftIcon: View {
	private let icon: SwiftIconDescriptor
	private let size: CGFloat?

	@ScaledMetric(relativeTo: .body)
	private var defaultSize: CGFloat = 20

	var finalSize: CGFloat {
		size ?? defaultSize
	}

	public init(_ icon: SwiftIconDescriptor, size: CGFloat? = nil) {
		self.icon = icon
		self.size = size
	}

	public var body: some View {
		Rectangle()
			.mask {
				SVGView(string: icon.rawSVG)
					.aspectRatio(1, contentMode: .fit)
			}
			.frame(width: finalSize , height: finalSize)
	}
}

// MARK: - Native image bridging for SwiftUI, UIKit, and AppKit.

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

extension SwiftIcon {
	/// Renders the vector icon as a SwiftUI `Image`.
	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
	@MainActor
	public func toImage() -> Image {
		let mainView = self.foregroundStyle(.black)
		let imageRenderer = ImageRenderer(content: mainView)

		#if canImport(UIKit)

		imageRenderer.scale = UIScreen.main.scale
		if let uiImage = imageRenderer.uiImage {
			return Image(uiImage: uiImage).renderingMode(.template)
		}

		#elseif canImport(AppKit)

		imageRenderer.scale = NSScreen.main?.backingScaleFactor ?? 2.0
		if let nsImage = imageRenderer.nsImage {
			return Image(nsImage: nsImage).renderingMode(.template)
		}

		#endif

		return Image(systemName: "questionmark.square.dashed")
	}

	#if canImport(UIKit)

	/// Renders the vector icon as a UIKit `UIImage`.
	@available(iOS 16.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
	@MainActor
	public func toUIImage() -> UIImage? {
		let mainView = self.foregroundStyle(.black)
		let imageRenderer = ImageRenderer(content: mainView)
		imageRenderer.scale = UIScreen.main.scale

		if let image = imageRenderer.uiImage {
			return image.withRenderingMode(.alwaysTemplate)
		}

		return UIImage(systemName: "questionmark.square.dashed") ?? UIImage()
	}

	#endif

	#if canImport(AppKit)

	/// Renders the vector icon as a native AppKit `NSImage`.
	@available(macOS 13.0, *)
	@MainActor
	public func toNSImage() -> NSImage? {
		let mainView = self.foregroundStyle(.black)
		let imageRenderer = ImageRenderer(content: mainView)
		imageRenderer.scale = NSScreen.main?.backingScaleFactor ?? 2.0
		if let nsImage = imageRenderer.nsImage {
			nsImage.isTemplate = true
			return nsImage
		}

		return NSImage(
			systemSymbolName: "questionmark.square.dashed",
			accessibilityDescription: nil
		) ?? NSImage()
	}

	#endif
}
