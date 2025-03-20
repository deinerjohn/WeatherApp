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
    var queries: [String:String] { get }
    var method: RequestMethod { get }
}
