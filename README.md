# Isometrik LiveStream SDK (ISMLiveStreamSDK)

This is the official Livestream SDK for integrating advanced streaming capabilities into your application. It includes a comprehensive set of features for live video broadcasting, stream chat interactions, and real-time viewer analytics, along with reusable UI components for seamless integration and more.

## Features we have to offer

- **Restreaming**: Broadcast your live stream simultaneously to multiple platforms, expanding your reach and audience engagement across various channels.

- **RTMP Streaming**: Support Real-Time Messaging Protocol (RTMP) for high-quality and low-latency live video streaming, compatible with a wide range of video platforms.

- **Single Live**: Enable a single live stream session, ideal for focused, high-quality broadcasts with a singular stream.

- **Multi Live**: Stream multiple live sessions concurrently, allowing for diverse content delivery and engaging multiple audiences at once.

- **PK Battle**: Host interactive "Player-Known" (PK) battles where viewers can participate in or watch competitive events in real-time.

- **Paid Stream**: Monetize your live streams by offering premium content access through paid subscriptions or one-time payments.


## Usage

1. Get your Ids and keys ready
   
For SDK to work you need to make sure you have these configurations ready before you move to initialize your SDK, ``accountId`` , ``projectId`` , ``keySetId`` , ``licensekey`` , ``appSecret`` , ``userSecret``, ``rtcAppId``

2. Initialize your SDK

call ``createConfiguration`` method for initialization

```swift
IsometrikSDK.getInstance().createConfiguration(
    accountId: accountId,
    projectId: projectId,
    keysetId: keySetId,
    licenseKey: licensekey,
    appSecret: appSecret,
    userSecret: userSecret,
    rtcAppId: rtcAppId,
    userInfo: streamUser
)
```

here streamUser is of ``ISMStreamUser`` type which is a custom type and takes these properties

``` swift
let userData = ISMStreamUser(
    userId: userId,
    name: name,
    identifier: identifier,
    imagePath: imagePath,
    userToken: userToken
)
```
3. Enable required features for liveStream

while creating configuration you can also provide stream option configurations in order to ``enable`` required feature, by default all features will be ``disabled``









