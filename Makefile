.PHONY: generate

generate:
	@echo "⚙️ Generating SwiftIcons.swift ..."
	swift run SwiftIconsGenerator
	@echo "🚀 Generation complete."

