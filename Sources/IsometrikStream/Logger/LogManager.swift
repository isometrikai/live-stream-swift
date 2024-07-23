
import os.log


final public class LogManager {
    public static let shared = LogManager()

    private let subsystem: String
    private let generalCategory = "General"
    private let networkCategory = "Network"
    private let databaseCategory = "Database"
    private let mqttCategory = "MQTT"
    private let liveKitCategory = "LiveKit"
    
    private init() {
        // Customize the subsystem name according to your app's identifier
        self.subsystem = "com.isometrik.app"
    }
    
    
    private func logger(for category: String) -> OSLog {
        return OSLog(subsystem: subsystem, category: category)
    }

    public func logGeneral(_ message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: logger(for: generalCategory), type: type, message)
    }

    public func logNetwork(_ message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: logger(for: networkCategory), type: type, message)
    }

    public func logDatabase(_ message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: logger(for: databaseCategory), type: type, message)
    }
    
    public func logMQTT(_ message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: logger(for: mqttCategory), type: type, message)
    }
    
    public func logLiveKit(_ message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: logger(for: liveKitCategory), type: type, message)
    }

    public func logCustom(category: String, message: String, type: OSLogType = .default) {
        os_log("%{public}@", log: logger(for: category), type: type, message)
    }
}
