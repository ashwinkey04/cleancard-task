# Cleancard task

## Approach
- Prioritized users understanding the image capture process, so sketched out the capture screen on paper (In `assets/paper-sketch.jpeg`).
- Added a home screen with guidelines to improve clarity which has three key instructions.
- Plotted the graph and a placeholder value called Average Biomarker Level which is the mean of the biomarker levels from the server in the results screen.

## Requirements
- Android device (v6.0 Marshmallow or higher)
- Internet connection

## Build instructions
- Extract the zip provided / clone [this repo](https://github.com/ashwinkey04/cleancard-task)
- Install Flutter and Android SDKs (Project built with Flutter 3.19.6 ) 
- Run `flutter build apk` to build the apk and install it on your device

> 💡 You can also install the apk directly after downloading from [here](https://github.com/ashwinkey04/cleancard-task/releases/download/v1/app-release.apk).

## Software Architecture
The app follows a clean architecture pattern with clear separation of concerns:

- `controllers/`: Contains business logic and state management (e.g. camera controller)
- `screens/`: Houses the UI screens and their specific logic
- `services/`: Manages external services like image upload
- `widgets/`: Reusable UI components used across screens

This modular structure ensures maintainability, testability and separation between UI, business logic and external services.

Due to the time constraint, I did not implement a dedicated state management system like provider or bloc. Instead, I used the inbuilt setState() function to update the UI whenever the state is required to be updated. This approach is not recommended for larger projects, but it works well for this project as it is a small and simple project.

## Tech and Tools
**Flutter** - Though I'm a tools agnostic person, I preferred to use Flutter for this project as this task's primary focus was on user experience and Flutter enables me to be good at that as well as building beautiful UIs. I'm also most experienced with Flutter, compared to anything else.

### Other tools
- **Claude Sonnet w/ Cursor**: I frequently use the code completion and generation features of Cursor using the Claude Sonnet model to primarily speed up the boring and repetitive tasks of my work like applying styles through natural language instead of manually specifying individual parameters, refactoring unorganized code to be more readable and efficient, and so on.
- **Render**: As this is an android app that should work on any device, I used [Render](https://render.com/) to host the provided server code on `https://cleancard-task.onrender.com/` and point the app's upload service to use this URL.

## Screen capture
- Available in `assets/screen-capture/complete-flow-encoded.mp4`


##### Misc
> For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.
