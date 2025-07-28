# Medibank iOS Code Challenge – SwiftUI Edition

## Challenge Overview

Build an an using SwiftUI where it will fetch and display trending articles from NewsAPI, allow users to filter by sources, and support saving articles for later reading.

#### News 
##### Main Navigation (Tab View)

App includes a TabView with three tabs:

1. Top Headlines Tab
	- Displays a list of articles based on selected sources.
	- Each row includes: title, description, author, thumbnail image, source and publisher details.
	- Tapping a row will open the article in a WebView within the app.
	- Users can save the article from this view.
	- Handled empty states gracefully (e.g., no sources selected, no results)

2. Sources Tab
	- Displays a list of available article sources (English only)
	- Users can select multiple sources
	- Selection is persisted across app launches

3. Saved Articles Tab
	- Displays a list of articles previously saved by the user
	- Tapping a saved article will open it in a WebView
	- Users can delete saved articles
	- Saved articles are persisted across app launches


##### Video

https://github.com/user-attachments/assets/f4dac3de-1d96-4627-a07e-97b1c0169262

##### Screens

1. **Main Screen**


| App Icon  | Launch Screen |
| ------------- | ------------- |
| <img width="200" height="435" alt="1 - Home Screen" src="https://github.com/user-attachments/assets/dd89b482-d0b1-4c9c-bada-a7c2d549f084" />  | <img width="200" height="435" alt="2 - Launch Screen" src="https://github.com/user-attachments/assets/7905c235-17bc-4f71-9db2-389740d21ce7" />  |

2. **Top Headlines**


| Loading  | Headlines | Article WebView | Error  | No Results |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| <img width="200" height="435" alt="3 4 - Headlines Loading" src="https://github.com/user-attachments/assets/c0b1e7a8-b059-4486-919e-bc1f1678ba8b" />  | <img width="200" height="435" alt="3 - Headlines" src="https://github.com/user-attachments/assets/a9aa0fd0-c1b3-4a07-ae5f-30ac0612fd69" />  | <img width="200" height="435" alt="6 - Article WebView" src="https://github.com/user-attachments/assets/decec54a-e2e4-490a-bb99-36e43e74d799" />  | <img width="200" height="435" alt="3 3 - Headlines Error" src="https://github.com/user-attachments/assets/89a82858-a286-4b1c-b120-b28c8ac379f8" />  | <img width="200" height="435" alt="3 2 - Headlines No Results" src="https://github.com/user-attachments/assets/9fbd2fdd-db8a-44a8-b052-80f5962d2522" />  |

3. **Sources Tab**

| Loading  | Sources | Error | No Results  | Selected |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| <img width="200" height="435" alt="4 1 - Sources Loading" src="https://github.com/user-attachments/assets/b23aa9d2-8638-40b9-a175-f4a8f567d415" />  | <img width="200" height="435" alt="4 - Sources" src="https://github.com/user-attachments/assets/6c4bade9-bc62-4273-a869-3fb9099045df" />  | <img width="200" height="435" alt="4 4 - Sources Error" src="https://github.com/user-attachments/assets/caceba4c-2dc5-481c-a0ed-1ed9fd7d5713" />  | <img width="200" height="435" alt="4 3 - Sources No Results" src="https://github.com/user-attachments/assets/c792bd70-a33d-488d-9cbd-4c347470736c" />  | <img width="200" height="435" alt="4 2 - Sources Selected" src="https://github.com/user-attachments/assets/ce303a2c-3977-4dcc-90ce-a227457d0392" />  |

4. **Saved Articles Tab**

| Saved  | Delete | Empty | Article WebView  | Error |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| <img width="200" height="435" alt="5 - Saved Articles" src="https://github.com/user-attachments/assets/e02901c8-1665-44fa-a608-665204eaf1f3" />  | <img width="200" height="435" alt="5 1 - Saved Articles Delete" src="https://github.com/user-attachments/assets/ac71c1b8-3ea2-474e-abc2-db5ed8ad8044" />  | <img width="200" height="435" alt="5 2 - Saved Articles Empty" src="https://github.com/user-attachments/assets/d2acf830-86e7-47d7-a6e7-dcf5b07b87d4" />  | <img width="200" height="435" alt="6 - Article WebView" src="https://github.com/user-attachments/assets/feac3057-083d-4575-a760-f1c60f0aa261" />  | <img width="200" height="435" alt="6 1 - Article WebView Error" src="https://github.com/user-attachments/assets/dd955346-5f2f-415f-b046-ec14b6dd33ab" />  |

## Technical Overview
Followed MVVM architecture, where the **View** binds to the **ViewModel's** observable outputs, updating the UI automatically when the ViewModel's data changes. User interactions in the View are sent as inputs to the ViewModel, which then processes them, interacts with the Model if needed, and updates its own state, which in turn triggers View updates.

## Code walk through
**NewsApp** is the main entry point for the app, we create **MainContentView** by passing the **SharedData** instance which holds the data that is shared between Headlines, Sources and Saved Articles screens.

In the body of MainContentView we created a TabView which hosts **HeadlinesView, SourcesView and SavedArticlesView**. The each view is given their ViewModel's instance while creating those views. 

HeadlinesView and SavedArticlesView share same kind of parent ViewModel(ArticlesViewModel) as the most of the functionality remains same except how they both source data.

**HeadlinesView**
HeadlinesView relies on HeadlinesViewState to update its content. Basically there are 4 states namely new, loading, successful and error. When there is an error, based on its type the UI is defined(noResultsFound and unknown). Unknown could be any generic error(since we don't have any specific usecase to show different UI for different error).

We used .task view modifier to initiate fetching of headlines when the view loads. Based on the different scenarios the state is updated and the view is updated accordingly.

When a headline(which is nothing but an article) is tapped, we show the headline in a WebView by using the url associated with headline.

**SourcesView**
SourcesView relies on SourcesViewState to update its content. Basically there are 4 states namely new, loading, successful and error. When there is an error, based on its type the UI is defined(noResultsFound and unknown). Unknown could be any generic error(since we don't have any specific usecase to show different UI for different error).

**SavedArticlesView**
SavedArticlesView relies on SavedArticlesViewModel to show the articles saved previously. 

**SharedData**
SharedData is a class that hosts the shared content between view and also takes care of saving the data to filesystem for later use.

**NetworkClient**
NetworkClient is used to make API calls and fetch response. It relies on EndpointConfiguration to understand which API call to invoke.

**DataManager**
DataManager is a utility that helps in saving and retrieving a codable complient object into filesystem.

**JsonLoader**
JsonLoader is used to decode mock json files for the previews to load.

**AsyncImageView**
AsyncImageView loads the image asynchronously handling the state of downloaded image.

**ArticleWebView**
ArticleWebView loads a given article in WebView(which hosts WKWebView). It also has an option to save the article.

**Model classes**
Source and Article are the model classes that are created when an API returns
SourceItem is used to capture the source selection

**UIApplicationDelegateAdaptor**
UIApplicationDelegateAdaptor is used to tap into the application state and save data before the app is killed.








