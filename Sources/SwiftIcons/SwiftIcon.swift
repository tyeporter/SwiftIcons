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
			.frame(width: size, height: size)
	}
}
