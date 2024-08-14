
public class ISMConfiguration {
    
    // Singleton instance
    public static let shared = ISMConfiguration()
    
    // Primary and secondary origins
    public let primaryOrigin: String
    public let secondaryOrigin: String
    
    // License and account details
    public var licenseKey: String
    public var accountId: String
    public var projectId: String
    public var keySetId: String
    
    // URLs and connection details
    public let liveKitUrl: String
    public let MQTTHost: String
    public let MQTTPort: Int
    public var rtcAppId: String
    public var rtcToken: String
    
    // Secrets
    public var appSecret: String
    public var userSecret: String
    public var userToken: String
    public var authToken: String
    
    // Private initializer to ensure the singleton pattern
    private init(
        primaryOrigin: String = "https://apis.isometrik.io",
        secondaryOrigin: String = "",
        liveKitUrl: String = "wss://streaming.isometrik.io",
        MQTTHost: String = "connections.isometrik.io",
        MQTTPort: Int = 2052,
        licenseKey: String = "",
        accountId: String = "",
        projectId: String = "",
        keySetId: String = "",
        rtcAppId: String = "",
        rtcToken: String = "",
        appSecret: String = "",
        userSecret: String = "",
        userToken: String = "",
        authToken: String = ""
    ) {
        self.primaryOrigin = primaryOrigin
        self.secondaryOrigin = secondaryOrigin
        self.liveKitUrl = liveKitUrl
        self.MQTTHost = MQTTHost
        self.MQTTPort = MQTTPort
        self.licenseKey = licenseKey
        self.accountId = accountId
        self.projectId = projectId
        self.keySetId = keySetId
        self.rtcAppId = rtcAppId
        self.rtcToken = rtcToken
        self.appSecret = appSecret
        self.userSecret = userSecret
        self.userToken = userToken
        self.authToken = authToken
    }
    
    // Method to update configuration (if necessary)
    public func updateConfig(
        licenseKey: String,
        accountId: String,
        projectId: String,
        keySetId: String,
        appSecret: String,
        userSecret: String,
        rtcToken: String,
        userToken: String,
        rtcAppId: String
    ) {
        self.rtcToken = rtcToken
        self.userToken = userToken
        self.licenseKey = licenseKey
        self.accountId = accountId
        self.projectId = projectId
        self.keySetId = keySetId
        self.appSecret = appSecret
        self.userSecret = userSecret
        self.rtcAppId = rtcAppId
    }
}

