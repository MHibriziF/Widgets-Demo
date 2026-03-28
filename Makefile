.PHONY: get gen watch run run-profile run-release run-web clean build-apk test format analyze doctor fix setup

## Install dependencies
get:
	flutter pub get

## Run code generation (freezed, json_serializable)
gen:
	dart run build_runner build --delete-conflicting-outputs

## Watch and re-run code generation on file changes
watch:
	dart run build_runner watch --delete-conflicting-outputs

## Run on the connected device (debug by default, or pass m=profile/release)
run:
	flutter run $(if $(m),--$(m),)

## Run in profile mode (DevTools performance profiling)
run-profile:
	flutter run --profile

## Run in release mode
run-release:
	flutter run --release

## Run on Chrome
run-web:
	flutter run -d chrome

## Clean build artifacts and reinstall packages
clean:
	flutter clean && flutter pub get

## Build a release APK
build-apk:
	flutter build apk --release

## Run tests
test:
	flutter test

## Format all Dart files
format:
	dart format lib/

## Analyze for issues
analyze:
	flutter analyze lib/

## Flutter Doctor
doctor:
	flutter doctor -v

## fix code
fix:
	dart fix lib/

## Full setup: install packages + run code generation
setup: get gen
	@echo "Setup complete. Run 'make run' to start the app."
