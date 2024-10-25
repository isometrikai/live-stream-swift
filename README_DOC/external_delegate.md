### Configuring Stream Delegates and Actions

Isometrik provides a delegate to handle various stream-related actions. Implement the `ISMExternalDelegate` protocol in your view controller to manage actions such as sharing or closing a stream. Below is an example implementation in Swift.

```swift
// Extension to conform to the ISMExternalDelegate protocol for handling stream actions
extension MyController: ISMExternalDelegate {

    // This function is triggered when the "Share Stream" action is tapped in the stream UI.
    // - Parameters:
    //   - streamData: A `SharedStreamData` object containing details of the stream to be shared.
    //   - root: The `UINavigationController` to present the share UI.
    func didShareStreamTapped(streamData: SharedStreamData, root: UINavigationController) {
        
        // Retrieve the stream ID from stream data to generate a shareable link
        let streamId = streamData.streamId
        let shareURL = URL(string: "https://yourdomain.com/stream/\(streamId)")!
        
        // Create an activity view controller to present sharing options to the user
        let activityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        
        // Exclude specific activity types from sharing options, if desired
        activityViewController.excludedActivityTypes = [
            .postToWeibo,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo
        ]
        
        // Present the activity view controller to enable sharing
        root.present(activityViewController, animated: true, completion: nil)
    }

    // This function is triggered when the "Close Stream" action is tapped.
    // - Note: This action is only triggered for viewers in the stream.
    // - Parameters:
    //   - memberData: Data associated with the host member of a stream.
    //   - callback: A callback function to handle the success status of the close action.
    //   - root: The `UINavigationController` to present the follow confirmation UI.
    func didCloseStreamTapped(memberData: ISMMember?, callback: @escaping (Bool) -> (), root: UINavigationController) {
        
        // Initialize a controller for handling the follow confirmation action
        let controller = DemoFollowViewController()
        
        // Set up a callback to notify of the close action's success
        controller.followActionCallback = { success in
            if success {
                DispatchQueue.main.async {
                    callback(success)
                }
            }
        }
        
        // User the host member id as per your requirement as added below
        if let memberData, let memberMetaData = memberData.metaData, let memberId = memberMetaData.userID {
            print("host member id: \(memberId)")
        }
        
        // Configure the sheet presentation with a custom height for modern iOS versions
        if let sheet = controller.sheetPresentationController {
            if #available(iOS 16.0, *) {
                sheet.detents = [.custom { context in
                    return context.maximumDetentValue * 0.6 // 60% of the available screen height
                }]
            } else {
                // Fallback on earlier versions
            }
            sheet.prefersGrabberVisible = true // Optional: shows a grabber for better UX
        }

        // Present the controller as a sheet to confirm the follow action
        root.present(controller, animated: true)
    }

}
