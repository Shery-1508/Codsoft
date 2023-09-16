Certainly! Here's a more detailed documentation for your Todo List App, including links to screenshots and download options for Android and a web version:

# Todo_List App Documentation

## Overview

The Todo List App is a Flutter-based mobile application designed to help users manage their tasks and to-do lists efficiently. This documentation provides an in-depth guide to the app's features, architecture, and how to use and customize it.

**Screenshots**:

![Screenshot 1](./screenshots/white_theme.png)
![Screenshot 1](./screenshots/black_theme.png)
![Screenshot 1](./screenshots/black_theme_drawer.png)
![Screenshot 1](./screenshots/addingtasks.png)

**Download**:

- [Android App](#android-app)
- [Web Version](#web-version)

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
3. [Features](#features)
    - [Adding Tasks](#adding-tasks)
    - [Task List](#task-list)
    - [Task Details](#task-details)
    - [Completing Tasks](#completing-tasks)
    - [Theme Toggle](#theme-toggle)
    - [Show Created Time](#show-created-time)
4. [Architecture](#architecture)
5. [Customization](#customization)
6. [Contributing](#contributing)
7. [License](#license)

## Introduction

The Todo List App is a simple yet powerful task management tool that allows users to create, manage, and track their tasks with ease. It offers various features such as task creation, task completion, theme customization, and more.

## Getting Started

### Prerequisites

Before you can run the Todo List App, make sure you have the following prerequisites installed:

- Flutter: Ensure you have Flutter SDK installed on your system. You can download it from [here](https://flutter.dev/docs/get-started/install).

### Plugins Used
The Todo List App utilizes the following Flutter plugins:

- shared_preferences: Version 2.0.8. This plugin is used for storing and retrieving user preferences, such as theme settings and task data persistence.
- provider: Version 6.0.1. Provider is used for state management, allowing widgets to access and update app-wide data efficiently.
- intl: Version 0.17.0. The intl package is used for internationalization and localization in the app, enabling support for multiple languages.

### Installation

1. Clone the repository from GitHub:

   ```bash
   git clone https://github.com/your-username/your-repo.git
   ```

2. Navigate to the project directory:

   ```bash
   cd your-repo
   ```

3. Install the required dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app on an emulator or physical device:

   ```bash
   flutter run
   ```

## Features

### Adding Tasks

- To add a new task, click the floating action button with a '+' icon on the home screen.
- Fill in the task name and an optional task description.
- Click the 'Add' button to create the task.

### Task List

- All created tasks are displayed on the home screen.
- Each task is represented by a card with its name and description (if available).
- Tasks are color-coded for visual distinction.

### Task Details

- To view the details of a task, tap on the task card.
- You can see the task name, description, creation time, and completion time (if completed).

### Completing Tasks

- To mark a task as completed, tap on the task card.
- The task card will change color, indicating completion.
- Optionally, you can enable or disable showing the completion time in the settings.

### Theme Toggle

- In the app's drawer, there is a switch to toggle between dark mode and light mode.
- This feature allows users to customize the app's appearance based on their preferences.

### Show Created Time

- In the app's drawer, there is a switch to show or hide the creation time of tasks on the task cards.
- Users can enable or disable this feature based on their preference.

## Architecture

The Todo List App follows a clean and structured architecture with separate files for different functionalities:

- `main.dart`: Entry point of the app, including theme setup and routing.
- `theme_notifier.dart`: A provider for theme management.
- `todo.dart`: Data model for tasks.
- `todo_item.dart`: Widget to display individual tasks.
- `todo_list_screen.dart`: Main screen with task management features and settings.

## Customization

The Todo List App can be customized in several ways:

- **Theme**: You can customize the app's theme by modifying the ThemeData in `main.dart`.
- **Colors**: Update the color scheme in `theme_notifier.dart`.
- **Strings**: Replace any text or strings in the app with your own content.
- **Icons**: Replace the app's icons with your preferred icons.

## Contributing

We welcome contributions from the community! If you find a bug, have an idea for an improvement, or want to add new features, please open an issue or submit a pull request on the GitHub repository.

## License

This project is open-source and available under the [MIT License](LICENSE). You are free to use and modify the code according to your needs.

## Screenshots

### Screenshot 1

![Screenshot 1](insert-screenshot-1-link-here)

### Screenshot 2

![Screenshot 2](insert-screenshot-2-link-here

)

## Download

### Android App

You can download the Android version of the Todo List App from [here](insert-android-app-link-here).

### Web Version

You can access the web version of the Todo List App from [here](insert-web-version-link-here).

---

Thank you for using the Todo List App! If you have any questions or need further assistance, please don't hesitate to contact us.

Happy task management!
