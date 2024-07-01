public class ISMConfiguration  {
    
    static let shared = ISMConfiguration()
    
    public  var primaryOrigin: String = "apis.isometrik.io"
    public  var secondaryOrigin: String = ""
    
    public  var licensekey: String = "lic-IMKPioj9hM3hMCh5eoeRC+d+l2TuxWOyPK3"
    public  var accountId: String = "5eb3db9ba9252000014f82ff"
    public  var projectId: String = "e1241039-2fef-4830-b927-5bb3424f1764"
    public  var keySetId: String = "40063abb-5af1-4fd4-a7f0-adc4767810b1"
    public  var liveKitUrl: String = "wss://streaming.isometrik.io"
    public  var MQTTHost: String = "connections.isometrik.io"
    public  var MQTTPort: Int = 2052
    public  var rtcAppId: String = "14948b513af4496aa57364eaab555893"
    public  var rtcToken: String = ""
    public var banubaClientToken: String?
    public var appSecret: String = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDVlYjNkYjliYTkyNTIwMDAwMTRmODJmZm0AAAAIa2V5c2V0SWRtAAAAJDQwMDYzYWJiLTVhZjEtNGZkNC1hN2YwLWFkYzQ3Njc4MTBiMW0AAAAJcHJvamVjdElkbQAAACRlMTI0MTAzOS0yZmVmLTQ4MzAtYjkyNy01YmIzNDI0ZjE3NjRkAAZzaWduZWRuBgAyRZTfiQE.Cd8oTBl0_bylLMQ45YXxUYqyIhbxstGEwCRIgLlQC3Y"
    
    public var userSecret: String = "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAADbQAAAAlhY2NvdW50SWRtAAAAGDVlYjNkYjliYTkyNTIwMDAwMTRmODJmZm0AAAAIa2V5c2V0SWRtAAAAJDQwMDYzYWJiLTVhZjEtNGZkNC1hN2YwLWFkYzQ3Njc4MTBiMW0AAAAJcHJvamVjdElkbQAAACRlMTI0MTAzOS0yZmVmLTQ4MzAtYjkyNy01YmIzNDI0ZjE3NjRkAAZzaWduZWRuBgA2RZTfiQE.ci4LzhsWp_E8bTTFVymYqWrCfCBm92uJ1QlczU1PvbY"
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
