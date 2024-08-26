# Setting up universal link on your app

Universal Links allow your app to handle links that open directly in your app instead of in Safari. This will guide you through the steps to set up Universal Links in your iOS app.

## Prerequisites

- Xcode 12 or later
- An Apple Developer account
- Access to your app's website or the ability to host a file on your domain

## Steps to Implement Universal Links

### 1. Update Your App's Entitlements

1. Open your Xcode project.
2. Navigate to the project settings.
3. Select your app target.
4. Go to the ``Signing & Capabilities`` tab.
5. Click the ``+ Capability`` button and add the **Associated Domains** capability.
6. In the ``Associated Domains`` section, add the following entry:

```bash
appLinks:yourdomain.com
```
   
Replace `yourdomain.com` with your actual domain.

### 2. Create and Host the Apple App Site Association File

1. Create a file named `apple-app-site-association` (without any file extension).
2. Add the following JSON content to the file:
```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.yourcompany.yourapp",
        "paths": [ "*" ]
      }
    ]
  }
}
```
3. upload JSON File at this path ``yourdomain.com/apple-app-site-association``
4. You domain should be ``SSL secured``, ``https://yourdomain.com``

And you're all set with the basic setup, Now

### 3. Configure Your App to Handle Universal Links

```swift
import UIKit
import IsometrikStream // Import this for accessing IsometirkSDK
import IsometrikStreamUI // Import this for accessing ISMExternalActions

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
           
      guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL,
           let components = URLComponents(url: url,
                                          resolvingAgainstBaseURL: true) else {
         return
      }
      
      // Extract stream id from path components
      
      let isometrikInstance = IsometrikSDK.getInstance() // get current isometrik instance
      let externalActions = ISMExternalActions(isometrik: isometrikInstance) // create object of external actions for accessing the methods
      externalActions.openStream(streamId: streamId, scene: scene as? UIWindowScene) // this method use to open the stream on SDK level it needs two parameters , 1. streamId 2. scene 
        
    }

}
```
