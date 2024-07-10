//public class ISMConfiguration  {
//    
//    static let shared = ISMConfiguration()
//    
//    public  var primaryOrigin: String = "apis.isometrik.io"
//    public  var secondaryOrigin: String = ""
//    
//    public  var licensekey: String = "lic-IMKPioj9hM3hMCh5eoeRC+d+l2TuxWOyPK3"
//    public  var accountId: String = "5eb3db9ba9252000014f82ff"
//    public  var projectId: String = "e1241039-2fef-4830-b927-5bb3424f1764"
//    public  var keySetId: String = "40063abb-5af1-4fd4-a7f0-adc4767810b1"
//    public  var liveKitUrl: String = "wss://streaming.isometrik.io"
//    public  var MQTTHost: String = "connections.isometrik.io"
//    public  var MQTTPort: Int = 2052
//    public  var rtcAppId: String = "14948b513af4496aa57364eaab555893"
//    public  var rtcToken: String = ""
//    public var banubaClientToken: String?
//    public var appSecret: String = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDVlYjNkYjliYTkyNTIwMDAwMTRmODJmZm0AAAAIa2V5c2V0SWRtAAAAJDQwMDYzYWJiLTVhZjEtNGZkNC1hN2YwLWFkYzQ3Njc4MTBiMW0AAAAJcHJvamVjdElkbQAAACRlMTI0MTAzOS0yZmVmLTQ4MzAtYjkyNy01YmIzNDI0ZjE3NjRkAAZzaWduZWRuBgAyRZTfiQE.Cd8oTBl0_bylLMQ45YXxUYqyIhbxstGEwCRIgLlQC3Y"
//    
//    public var userSecret: String = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDVlYjNkYjliYTkyNTIwMDAwMTRmODJmZm0AAAAIa2V5c2V0SWRtAAAAJDQwMDYzYWJiLTVhZjEtNGZkNC1hN2YwLWFkYzQ3Njc4MTBiMW0AAAAJcHJvamVjdElkbQAAACRlMTI0MTAzOS0yZmVmLTQ4MzAtYjkyNy01YmIzNDI0ZjE3NjRkAAZzaWduZWRuBgA2RZTfiQE.ci4LzhsWp_E8bTTFVymYqWrCfCBm92uJ1QlczU1PvbY"
//    public var userToken: String = ""
//    public var authToken: String = ""
//    
//    // MARK:- Product configurations
//    
//    public var storeCategoryId: String = ""
//    public var lang: String = "en"
//    public var language: String = "en"
//    public var currencyCode: String = ""
//    public var currencySymbol: String = ""
//    
//    //:
//    
//    public init() {}
//    
//}


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
    
    // Product configurations
    public var storeCategoryId: String
    public var lang: String
    public var language: String
    public var currencyCode: String
    public var currencySymbol: String
    
    // Private initializer to ensure the singleton pattern
    private init(
        primaryOrigin: String = "apis.isometrik.io",
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
        authToken: String = "",
        storeCategoryId: String = "",
        lang: String = "en",
        language: String = "en",
        currencyCode: String = "",
        currencySymbol: String = ""
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
        self.storeCategoryId = storeCategoryId
        self.lang = lang
        self.language = language
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
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
        authToken: String,
        storeCategoryId: String,
        lang: String,
        language: String,
        currencyCode: String,
        currencySymbol: String,
        rtcAppId: String
    ) {
        self.rtcToken = rtcToken
        self.userToken = userToken
        self.authToken = authToken
        self.licenseKey = licenseKey
        self.accountId = accountId
        self.projectId = projectId
        self.keySetId = keySetId
        self.appSecret = appSecret
        self.userSecret = userSecret
        self.storeCategoryId = storeCategoryId
        self.lang = lang
        self.language = language
        self.currencyCode = currencyCode
        self.currencySymbol = currencySymbol
        self.rtcAppId = rtcAppId
    }
}

