build:
	swift build

xcode:
	swift package generate-xcodeproj
	open ./CommandLine.xcodeproj
