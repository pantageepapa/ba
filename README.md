## Getting Started

This project is the implementation part of my bachelor thesis. The app aims to help depressed people using their Spotify data. 

## How to Use
**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/pantageepapa/ba.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 3:**

Execute this command to launch the app: 

```
flutter run
```

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- models/
|- pages/
|- services/
|- main.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- models - Contains store(s) for state-management of the application, to connect the reactive data of the application with the UI.
2- pages - Contains all the ui of the project, contains sub directory for each screen.
3- services - Contains the utilities/common functions of the application. 
4- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```
