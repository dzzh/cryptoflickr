# CryptoFlickr

`CryptoFlickr` is a simple iOS application that queries Flickr API and presents the results inside of a `UICollectionView`. This application was developed as a coding assignment when looking for a new job. You can find a full list of requirements for this project in [requirements.md](https://github.com/dzzh/cryptoflickr/blob/master/requirements.md).

You might wonder why this application has _crypto_ in its name. Well, everything is better with _crypto_ in 2018.  

## Technology stack

The project was implemented in Xcode 9 using Swift 4 without third-party libraries. It targets iOS 11.

## Architecture    

The project has several layers, including data models, networking, a service layer and a UI flow. CryptoFlickr consists of two production modules, namely `CryptoCore` and `CryptoFlickr`. The former module contains non-UI layers, the latter one contains UI-related code and all the glue code necessary to launch the app. Each production module has a corresponding testing module.

Network models are decoded from JSON using new `JSONDecoder` API. Decoding the models is a responsibility of a network layer.

The network layer is a simple wrapper over `URLSession` API. General requests (e.g. `/GET` requests retrieving JSON files) work with a shared `URLSession`, image downloads are routed through a different `URLSession` that invalidates each time the new search query is submitted. This allows to cancel pending image download requests that are still running for the previous query. The images are cached on disk using `URLCache`.  

The service layer consists of an image downloader and a service locator. While using a locator to wrap a single service might be an overkill, I decided to keep it because it help to encapsulate the networking code from `CryptoFlickr` module.

The image downloader can download image urls for a given query and search page, download an image and cancel running image requests. This is a generic API with one Flickr-specific implementation.   

As there's only one screen in the app, there's only one UI flow. It's implemented with MVVM approach. We have an `ImageBrowserViewController` that has a programmatically-created view and is backed by a view model.

The view has a search bar, a collection view to show the search results and the empty state view that overlaps the collection view when necessary. Initially, I planned to embed the search bar into a navigation bar, but struggled to make the search bar work together with the collection view, so decided to just have it on top of the collection.

The view controller owns the view model and uses it to receive search result updates. When a view event happens (search button tapped or the collection is scrolled to the bottom), the view controller requests the view model to provide it with the necessary search results and updates the view state after the view model triggers its completion block. If the view model fails, the view controller shows the alert describing the error. 

The view controller acts as a delegate of a collection view, the view model acts as its data source.

The view model allows to start a new search for a given search query or fetch more results for the current query. It has a mechanism to prevent running the same query for multiple times (this is important for the infinite scrolling). The view model stores the URLs of search results in an internal data structure to make them available to the collection view. It guarantees that no duplicate images will be shown when fetching adjacent search result pages.

## Screenshots

![Initial screen](https://raw.githubusercontent.com/dzzh/cryptoflickr/master/Screenshots/cryptoflickr-initial-screen.png) 
![Search results](https://raw.githubusercontent.com/dzzh/cryptoflickr/master/Screenshots/cryptoflickr-search-results.png) 

## Time effort

I spent approximately 16 hours on this project. This time was distributed roughly as follows:
* Think on the best possible project name, start a new Xcode project, play with fonts and colors at the launch screen, enjoy the other delightful forms of procrastination - 1 hour.
* Read documentation about this and that - 1.5 hours. 
* Implement the interface - 3 hours. As mentioned before, I struggled with making a search bar and a collection view work together.
* Implement the network layer, the service layer and network models - 6 hours. This involved quite some experimentation with different approaches.
* Implement infinite scrolling and images caching - 1.5 hours.
* Polish the code, add some documentation - 0.5 hours.
* Implement unit tests - 1.5 hours.
* Write readme, review the code - 1 hour.

All in all, this was a nice project to implement. It all looked pretty simple after reading the requirements, but there were certain tricky parts that required some careful planning. I don't think though that doing it all in five hours was realistic. Anyway, it was fun to work on this project, I wish you guys to have fun while reviewing it as well. 
  
## License

This gorgeous `CryptoFlickr` is available under the MIT license. See LICENSE file for more details.

