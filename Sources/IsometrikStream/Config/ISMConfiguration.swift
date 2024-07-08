public class ISMConfiguration  {
    
    static let shared = ISMConfiguration()
    
    public  var primaryOrigin: String = "apis.isometrik.io"
    public  var secondaryOrigin: String = ""
    
    public  var licensekey: String = ""
    public  var accountId: String = ""
    public  var projectId: String = ""
    public  var keySetId: String = ""
    public  var liveKitUrl: String = "wss://streaming.isometrik.io"
    public  var MQTTHost: String = "connections.isometrik.io"
    public  var MQTTPort: Int = 2052
    public  var rtcAppId: String = ""
    public  var rtcToken: String = ""
    public var banubaClientToken: String?
    public var appSecret: String = ""
    
    public var userSecret: String = ""
    public var userToken: String = ""
    public var authToken: String = ""
    
    // MARK:- Product configurations
    
    public var storeCategoryId: String = ""
    public var lang: String = "en"
    public var language: String = "en"
    public var currencyCode: String = ""
    public var currencySymbol: String = ""
    
    //:
    
    public init() {}
    
}
