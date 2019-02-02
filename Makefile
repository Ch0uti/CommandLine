build:
	@swift package update
	@swift build

test:
	@swift test

xcode:
	@echo "Generate Xcode project..."
	@swift package generate-xcodeproj
	@open ./CommandLineKit.xcodeproj

# Run swiftformat.
format:
	@swift run swiftformat .

# Cleanup.
clean:
	@echo "Clean build cache."
	@swift package clean
	@rm -f ./Package.resolved
