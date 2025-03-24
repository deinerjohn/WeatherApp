# Weather Demo App  

![Weather App Demo](Assets/readme/app_overview.gif)

## Overview

This demo app is inspired by the Weather App on iOS, this project fetches data from API and caching data local. It is structured on a **Clean Architecture** pattern and follows the **SOLID principle**, making it scalable and maintainable.


## 📱 Features  
✔️ Fetches weather data from **OpenWeatherMap API**  

✔️ Supports **offline caching** using SQLite  

✔️ Displays detailed weather information with **dynamic backgrounds**  

✔️ Implements **Lottie animations** for custom loading indicator

✔️ Ability to change the temperature Units (Imperial/Celcius)

✔️ Ability to delete cached weather data by sliding the list.

✔️ Search ability for countries, data coming from countries.json stored in bundle project


## 🏗️ Clean Architecture

This project structured into four layers, packing it seperately using **Swift Package Manager (SPM)** for modularity and scalability.

#### ❶ Domain Layer
Responsible for Business rules. It is considered independent of frameworks.

+ **![Domain Layer](Assets/readme/domain_layer.png)**

+ **SOLID principles**

  ✔️ Single Responsibility

  ✔️ Interface Segregation

#### ❷Data Layer
Handles Data retrieval (API, local storing, conversion)
+ **![Data Layer](Assets/readme/data_layer.png)**

+ **SOLID principles**

  ✔️ Liskov Substitution

  ✔️ Dependency Inversion

#### ❸Infrastructure Layer
It holds external dependencies such as, Network, Monitoring, Logger, Utilities.
+ **![Infrastructure Layer](Assets/readme/infrastructure_layer.png)**

+ **SOLID principles**

✔️ Open-Closed Principle

✔️ Single Responsibility

#### ❹Presentation Layer
Basically handles UI, state management. Holds SwiftUI Views and View Models.
+ **![Presentation Layer](Assets/readme/presentation_layer.png)**

+ **SOLID principles**

✔️ Open-Closed Principle

✔️ Dependency Inversion


## Installation
> 1. **Clone the Repository**:
>    ```bash
>    git clone https://github.com/deinerjohn/WeatherApp.git
>    cd weather-app
>    ```
> 2. **Install Dependencies**:
>    ```swift
>    swift package resolve  // Resolves SPM dependencies
>    ```
> 3. **Run the App in Xcode**
  
## Technology Used

+ SwiftUI – Modern UI Framework

+ Combine – Data binding & state management

+ OpenWeatherMap API – Weather data provider

+ Concurrency - Async/await task.

+ SQLite – Offline caching

+ Lottie – Custom loading indicator

+ Network Framework – Internet monitoring

+ Swift Package Manager (SPM) – Modular architecture (Used for external dependencies)

## Features in Action

+ Search for a country, and used the main city. (List of countries stored in 'countries.json')

+ Show detailed view for cached weather data.

+ Able to add and delete weather data. (Offline caching)

+ Network monitor. (Checking if network is reachable)

+ Toggle temperature units (Celcius/Fahrenheit)

## License
Feel free to use

## Author

Deiner John P. Calbang

