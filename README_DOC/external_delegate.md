### Configuring Stream Delegates and Actions

Isometrik provides a delegate to handle various actions, which requires conforming to the `ISMExternalDelegate` protocol. An example implementation is provided below:

```swift

extension MyController: ISMExternalDelegate {

  func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController) {
          
      // Generate the shareable link using the stream Id provided by this delegate method
      let streamId = streamData.streamId
      let shareURL = URL(string: "https://yourdomain.com/stream/\(streamId)")!
      
      // Open the share activity controller
      let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
  
      // Optionally, exclude certain activity types
      activityViewController.excludedActivityTypes = [
          .postToWeibo,
          .assignToContact,
          .saveToCameraRoll,
          .addToReadingList,
          .postToFlickr,
          .postToVimeo,
          .postToTencentWeibo
      ]
  
      // Present the activity view controller
      root.present(activityViewController, animated: true, completion: nil)
  
  }

}
