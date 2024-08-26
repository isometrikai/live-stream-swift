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
