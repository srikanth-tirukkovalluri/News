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

##### Screens

1. **Main Screen**


| App Icon  | Launch Screen |
| ------------- | ------------- |
| <img width="200" height="435" alt="1 - Home Screen" src="https://github.com/user-attachments/assets/dd89b482-d0b1-4c9c-bada-a7c2d549f084" />  | <img width="200" height="435" alt="2 - Launch Screen" src="https://github.com/user-attachments/assets/7905c235-17bc-4f71-9db2-389740d21ce7" />  |





2. **Top Headlines**


| Loading  | Headlines | Article WebView | Error  | No Results | No Sources Selected |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| <img width="200" height="435" alt="3 4 - Headlines Loading" src="https://github.com/user-attachments/assets/c0b1e7a8-b059-4486-919e-bc1f1678ba8b" />  | <img width="200" height="435" alt="3 - Headlines" src="https://github.com/user-attachments/assets/a9aa0fd0-c1b3-4a07-ae5f-30ac0612fd69" />  | <img width="200" height="435" alt="6 - Article WebView" src="https://github.com/user-attachments/assets/decec54a-e2e4-490a-bb99-36e43e74d799" />  | <img width="200" height="435" alt="3 3 - Headlines Error" src="https://github.com/user-attachments/assets/89a82858-a286-4b1c-b120-b28c8ac379f8" />  | <img width="200" height="435" alt="3 2 - Headlines No Results" src="https://github.com/user-attachments/assets/9fbd2fdd-db8a-44a8-b052-80f5962d2522" />  | <img width="200" height="435" alt="3 1 - Headlines No Sources Selected" src="https://github.com/user-attachments/assets/8a4ee547-c61f-43e8-b6ba-53f1eb37fc7a" />  |

3. **Sources Tab**

| Loading  | Sources | Error | No Results  | Selected |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| <img width="200" height="435" alt="4 1 - Sources Loading" src="https://github.com/user-attachments/assets/b23aa9d2-8638-40b9-a175-f4a8f567d415" />  | <img width="200" height="435" alt="4 - Sources" src="https://github.com/user-attachments/assets/6c4bade9-bc62-4273-a869-3fb9099045df" />  | <img width="200" height="435" alt="4 4 - Sources Error" src="https://github.com/user-attachments/assets/caceba4c-2dc5-481c-a0ed-1ed9fd7d5713" />  | <img width="200" height="435" alt="4 3 - Sources No Results" src="https://github.com/user-attachments/assets/c792bd70-a33d-488d-9cbd-4c347470736c" />  | <img width="200" height="435" alt="4 2 - Sources Selected" src="https://github.com/user-attachments/assets/ce303a2c-3977-4dcc-90ce-a227457d0392" />  |

4. **Saved Articles Tab**

| Saved  | Delete | Empty | Article WebView  | Error |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| <img width="200" height="435" alt="5 - Saved Articles" src="https://github.com/user-attachments/assets/e02901c8-1665-44fa-a608-665204eaf1f3" />  | <img width="200" height="435" alt="5 1 - Saved Articles Delete" src="https://github.com/user-attachments/assets/ac71c1b8-3ea2-474e-abc2-db5ed8ad8044" />  | <img width="200" height="435" alt="5 2 - Saved Articles Empty" src="https://github.com/user-attachments/assets/d2acf830-86e7-47d7-a6e7-dcf5b07b87d4" />  | <img width="200" height="435" alt="6 - Article WebView" src="https://github.com/user-attachments/assets/feac3057-083d-4575-a760-f1c60f0aa261" />  | <img width="200" height="435" alt="6 1 - Article WebView Error" src="https://github.com/user-attachments/assets/dd955346-5f2f-415f-b046-ec14b6dd33ab" />  |




