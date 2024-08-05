# Isometrik LiveStream SDK

This is the official Livestream SDK for integrating advanced streaming capabilities into your application. It includes a comprehensive set of features for live video broadcasting, stream chat interactions, and real-time viewer analytics, along with reusable UI components for seamless integration and more.

## Features we have to offer

- **Restreaming**: Broadcast your live stream simultaneously to multiple platforms, expanding your reach and audience engagement across various channels.

- **RTMP Streaming**: Support Real-Time Messaging Protocol (RTMP) for high-quality and low-latency live video streaming, compatible with a wide range of video platforms.

- **Single Live**: Enable a single live stream session, ideal for focused, high-quality broadcasts with a singular stream.

- **Multi Live**: Stream multiple live sessions concurrently, allowing for diverse content delivery and engaging multiple audiences at once.

- **PK Battle**: Host interactive "Player-Known" (PK) battles where viewers can participate in or watch competitive events in real-time.

- **Paid Stream**: Monetize your live streams by offering premium content access through paid subscriptions or one-time payments.


## Setup

1. Get your Ids and keys ready
   
For SDK to work you need to make sure you have these configurations ready before you move to initialize your SDK, ``accountId`` , ``projectId`` , ``keySetId`` , ``licensekey`` , ``appSecret`` , ``userSecret``, ``rtcAppId``

2. Initialize your SDK

call ``createConfiguration`` method for initialization

```swift

let streamUser = ISMStreamUser(
    userId: userId,
    name: name,
    identifier: identifier,
    imagePath: imagePath,
    userToken: userToken
)

IsometrikSDK.getInstance().createConfiguration(
    accountId: "YOUR ACCOUNT ID",
    projectId: "YOUR PROJECT ID",
    keysetId: "YOUR KEYSET ID",
    licenseKey: "YOUR LICENSE KEY",
    appSecret: "YOUR APP SECRET",
    userSecret: "YOUR USER SECRET",
    rtcAppId: "YOUR RTCAPP ID",
    userInfo: streamUser
)
```

here streamUser is of ``ISMStreamUser`` type which is a custom type and takes these properties mentioned above.

3. Enable required features for liveStream

while creating configuration you can also provide stream option configuration in order to ``enable`` required feature, by default all features will be ``disabled``

```swift
let streamOptionsConfig = ISMOptionsConfiguration(
   enableGroupStream: true, // This will enable group streaming 
   enablePKStream: true, // This will enable PK stream feature
   enableProductInStream: true, // This will enable Ecommerce/product for a stream
   enableRTMPStream: true, // This will enable RTMP stream
   enablePaidStream: true, // This will enable Paid/Promotional stream feature
   enableRestream: true, // This will enable restream feature for a stream
   enableScheduleStream: true // This will enable schedule stream feature
)

IsometrikSDK.getInstance().createConfiguration(
    ....,
   streamOptionsConfiguration: streamOptionsConfig
)
```

## On Termination or Logout

While loggingOut the app remember to call this ``onTerminate`` method to prevent shared instances issues

```swift
IsometrikSDK.getInstance().onTerminate()
```









