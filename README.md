# SuperHero Directory iOS App
**iOS Swift/Storyboard Example**

Welcome to my SuperHero Directory iOS App, where I read in all of the SuperHeroes, their biographies, and events they are featured in from Marvel's API.

In this app, all data is persisted using CoreData. After the first load of the app, all the SuperHeroes, and their biographies are saved to your device. If you click on an individual SuperHero on the Directory screen, the events will be read in from the Marvel API and persisted.

I used four third-party libraries:

AlamoFire was used for HTTP network calls from the Marvel API.
Lottie was used to display an animation while waiting for the SuperHeroes to load on the Directory Screen.
CryptoSwift was used to create the md5 digest of the timestamp parameter, private key and public key to use the Marvel API.
Kingfisher was used to load and cache images from a remote URL.

I included a few examples of unit tests and UI tests using Apple's XCTest framework.

The app supports iOS 12.1+, uses UIKit and Storyboard, and designed using MVVM architecture.

Feel free to try the app yourself!

Mark Dalton
