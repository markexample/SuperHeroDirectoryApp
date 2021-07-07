# SuperHero Directory iOS App
**iOS Swift/Storyboard Example**

<img src="https://drive.google.com/uc?export=download&id=1S_XwQXA-I6QCpwWXXcWG9Q0oAy6D7c0e" width="200" />
<img src="https://drive.google.com/uc?export=download&id=1nZetZemnMpNdX3bkjet593ILjwuCkrB9" width="200" />

Welcome to my Superhero Directory iOS App, where I read in all of the Superheroes, their biographies, and events they are featured in from Marvel's API.

In this app, all data is persisted using CoreData. After the first load of the app, all the Superheroes and their biographies are saved to your device. If you click on an individual Superhero on the Directory screen, the events will be read in from the Marvel API and persisted.


I used four third-party libraries:

- Alamofire was used for HTTP network calls from the Marvel API.

- Lottie was used to display an animation while waiting for the Superheroes to load on the Directory Screen.

- CryptoSwift was used to create the md5 digest of the timestamp parameter, private key and public key to use the Marvel API.

- Kingfisher was used to load and cache images from a remote URL.


I included a few examples of unit tests and UI tests using Apple's XCTest framework.

The app supports iOS 12.1+, uses UIKit and Storyboard, and designed using MVVM architecture.

Feel free to try the app yourself!

Mark Dalton
