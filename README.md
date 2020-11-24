# Marvel Heroes

[![Coverage Status](https://coveralls.io/repos/github/mayckonx/MarvelHeroesApp/badge.svg?branch=feature/increase-unit-test)](https://coveralls.io/github/mayckonx/MarvelHeroesApp?branch=feature/increase-unit-test)

Your favorite Marvel characters in one app. 

## Features

- Fetch an online list of the marvel characters ✅

- See the details of your favorite character when selecting a cell ✅

- Search for specific characters by their names ✅

- Use it on iPad and iPhone ✅

- Support to Portrait and Landscape ✅

## Architecture
We are using the MVVM-C with a slight change: We have renamed our ViewModel to Reactor. We use a unidirectional flow between the View and the Reactor. 

What is a Reactor? 

A Reactor is an UI-independent layer that manages the state of a view. The foremost role of a reactor is to separate control flow from a view. Every view has its corresponding reactor and delegates all logic to its reactor. A reactor has no dependency to a view, so it can be easily tested.

The code is designed for simplicity, reussbility and testability. All classes are tested.

## A common problem in MVVM using RxSwift...
While using the traditional bindings between a View and a View Model, we might end up having several communications going on, and to make it even harder there are also the side effects. The image below speaks for itself.

![alt text](https://miro.medium.com/max/1400/1*vqp2r2S0JI406TMaxUsI9A.png)

## How MVVM with the unidirectional flow helps to solve this problem? 

By using unidirectional flow into the View Model, we have the following benefits:
-  Combining all inputs into one stream containing an enum of user intents
-  Combining all outputs into one stream of state objects
- The Reactor(ViewModel) reacts to user input and triggers an output as a `State`, regardless of the side effects.
- The view listens to the state and reacts to it accordingly. 
- It's very easy to test as we just have to provide inputs and expect outputs(See the `CharactersReactorTest` for instance)

That being said, we can achieve the following result: 
![alt text](https://miro.medium.com/max/1400/1*ZnsQKDlAv_E1SG_GyHqVPg.png)

## Project Structure
The project is structured in multiple targets: 
- 🦸‍♂️ **MarvelHeroes** - The app's main target. It uses all other targets as dependencies.

- 🧿 **Core** - The core target provides the base and reusable classes and extensions that can be used by the main target. For instance: classes such as a `BaseCoordinator`, useful extensions for `RxSwift`, `UIKit` and so on.

- 📡 **Network**  - Provides an abstraction of the network layer as a service. Through this target, we can use all operations we need for network requests. Furthermore, as we just expose the API we can easily replace the network framework/components without affecting the Network's target consumers.

- 📒 **Domain**  - Provides raw structs of models that are being used in the project. 

## Libraries
- **RxSwift** - Reactive programming for Swift
- **ReactorKit** - Reactive and unidirectional Swift application architecture
- **SnapKit** - DSL to make Auto Layout easy on iOS.
- **Kingfisher** - Library for downloading and caching images from the web
- **Moya** - Network abstraction layer.
- **RxExpect** - A testing framework for RxSwift


