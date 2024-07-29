import Foundation
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

    private func formattedMessage(_ message: String, type: OSLogType, file: String, line: Int) -> String {
        let prefix = LogManager.prefixes[type.rawValue] ?? ""
        let fileName = (file as NSString).lastPathComponent
        return "\(prefix) [\(type.description)] [\(fileName):\(line)] > \(message)"
    }

    public func logGeneral(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: generalCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logNetwork(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: networkCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logDatabase(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: databaseCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logMQTT(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: mqttCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logLiveKit(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: liveKitCategory), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logCustom(category: String, message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        os_log("%{public}@", log: logger(for: category), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    // Define the prefixes for each log type
    private static let prefixes: [UInt8: String] = [
        OSLogType.info.rawValue: "ℹ️",
        OSLogType.debug.rawValue: "🛠",
        OSLogType.error.rawValue: "🚨",
        OSLogType.fault.rawValue: "💥",
        OSLogType.default.rawValue: ""
    ]
}

private extension OSLogType {
    var description: String {
        switch self {
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        case .error:
            return "ERROR"
        case .fault:
            return "FAULT"
        default:
            return "DEFAULT"
        }
    }
}
