# muskul

A new Flutter project.

## run

-start emulator: `flutter emulators --lauch <emu id>`
-run build

To check what emulators are available call: `flutter emulators`
If no emulator are available You need to install one.

## development

For differen run types app use flavors. You have to put you `google-service.json` into specific folder.

### dev

-json folder: `android/app/src/dev`
-command: `flutter run --flavor dev`

### prod

-json folder: `android/app/src/prod`
-command: `flutter run --flavor prod`

## build

Build ready to install on real device.

-apk: `flutter build apk --split-per-abi --flavor prod`
-aab: `flutter build appbundle --flavor prod`
