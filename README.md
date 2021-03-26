# CSCI310-Group14
Trojan Check In/Out

## Required Systems/Software for Testing
* MacOS that can run XCode 12
* XCode 12
* CocoaPods

## Build Instructions
* Unzip project
* Run ```pod install``` in terminal while in the project directory
* Open the generated ```xcworkspace``` file. It should open up in XCode
* Click the Play button on the top left to build the project.
* Once the project is finished building, it should automatically open up an emulator.

## To Test CSV Upload in the emulator
* With the emulator running, drag a properly formatted CSV file (an example buildings.csv is included in the repo) onto the emulator. A window should pop up asking whether you want to save it to the Emulator's files or iCloud.
* Navigate to the Add Building scene
* Click the upload button and the csv file uploaded earlier should be selectable
