//
//  Logger.swift
//  Domain
//
//  Created by Deiner John Calbang on 3/20/25.
//

import Foundation

public enum Logger {

    fileprivate enum `Type`: String {
        case verbose = "🔵🔵🔵"
        case debug = "🟢🟢🟢"
        case error = "🔴🔴🔴"
    }

    // MARK: - Properties
    private static let mainTag = "WeatherApp__"
    private static let concurrentListenersQueue = DispatchQueue(label: "com.sample.weatherApp.concurrentListenersQueue",
                                                                qos: .background,
                                                                attributes: .concurrent)
}

// MARK: - Public methods
public extension Logger {

    static func debug(_ msg: String, tag: String? = #function, file: String? = #file, line: Int? = #line) {
        log(msg, tag: tag, type: .debug, file: file, line: line)
    }

    static func error(_ msg: String, tag: String? = #function, file: String? = #file, line: Int? = #line) {
        log(msg, tag: tag, type: .error, file: file, line: line)
    }

    static func verbose(_ msg: String, tag: String? = #function, file: String? = #file, line: Int? = #line) {
        log(msg, tag: tag, type: .verbose, file: file, line: line)
    }
}

// MARK: - Private methods
private extension Logger {

    static func log(_ msg: String, tag: String? = nil, type: Type, file: String? = nil, line: Int? = nil) {
        concurrentListenersQueue.async(flags: .barrier) {
            var message = "\n" + self.mainTag + "\(type.rawValue) |"
            let encodedFile = file?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let url = URL(string: encodedFile ?? "") {
                message += " \(url.lastPathComponent) |"
            } else if let file = file {
                message += " \(file) |"
            }

            if let tag = tag { message += " \(tag) |" }
            if let line = line { message += " \(line) |" }
            message += " \(msg) ||"
            self.printMessage(message)
        }
    }

    static func printMessage(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
