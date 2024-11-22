import Foundation
import os.log

final public class LogManager {
    public static let shared = LogManager()

    // Property to enable or disable logging
    public var isLoggingEnabled: Bool = true

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

    // Helper function to check if logging is enabled
    private func logIfEnabled(_ category: String, message: String, type: OSLogType, file: String, line: Int) {
        guard isLoggingEnabled else { return }
        os_log("%{public}@", log: logger(for: category), type: type, formattedMessage(message, type: type, file: file, line: line))
    }

    public func logGeneral(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        logIfEnabled(generalCategory, message: message, type: type, file: file, line: line)
    }

    public func logNetwork(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        logIfEnabled(networkCategory, message: message, type: type, file: file, line: line)
    }

    public func logDatabase(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        logIfEnabled(databaseCategory, message: message, type: type, file: file, line: line)
    }

    public func logMQTT(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        logIfEnabled(mqttCategory, message: message, type: type, file: file, line: line)
    }

    public func logLiveKit(_ message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        logIfEnabled(liveKitCategory, message: message, type: type, file: file, line: line)
    }

    public func logCustom(category: String, message: String, type: OSLogType = .default, file: String = #file, line: Int = #line) {
        logIfEnabled(category, message: message, type: type, file: file, line: line)
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
