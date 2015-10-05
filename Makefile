BUILD_TOOL = xctool
BUILD_PLATFORM = iphonesimulator
BUILD_DESTINATION_NAME = iPhone 6
BUILD_ARGUMENTS = -workspace MobilePlayer.xcworkspace -scheme MobilePlayer -derivedDataPath build -sdk $(BUILD_PLATFORM) -destination 'platform=$(BUILD_PLATFORM),name=$(BUILD_DESTINATION_NAME)'
PACKAGE_IDENTIFIER = com.movielala.MobilePlayer

default: test

install:
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update && brew upgrade
	brew install xctool

build:
	$(BUILD_TOOL) $(BUILD_ARGUMENTS)

test:
	$(BUILD_TOOL) $(BUILD_ARGUMENTS) test

run:
	xcrun instruments -w '$(BUILD_DESTINATION_NAME)'
	xcrun simctl install booted build/Debug-iphonesimulator/MobilePlayer.app
	xcrun simctl launch booted $(PACKAGE_IDENTIFIER)

clean:
	$(BUILD_TOOL) $(BUILD_ARGUMENTS) clean
