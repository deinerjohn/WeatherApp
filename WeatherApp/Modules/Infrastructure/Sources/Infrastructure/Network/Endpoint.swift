//
//  Endpoint.swift
//  Infrastructure
//
//  Created by Deiner John Calbang on 3/20/25.
//

import Foundation

//MARK: - HTTPS Methods
public enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

public protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var queries: [String:String] { get }
    var method: RequestMethod { get }
    var apiKey: String { get }
}

public extension Endpoint {
    var apiKey: String {
        return "7946421d36806460abbcbd28837c68d6"
    }
}
