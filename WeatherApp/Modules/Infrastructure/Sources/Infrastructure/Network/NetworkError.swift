//
//  NetworkError.swift
//  Infrastructure
//
//  Created by Deiner John Calbang on 3/20/25.
//

import Foundation

enum NetworkError: Error {
    
    case invalidUrl
    case noResponse
    case decodeError
    case unexpectedStatusCode
    case unknown
    case expiredToken
    case cancelledRequest
    
    var debugDescription: String {
        switch self {
        default:
            return "ADD custom debug description"
        }
    }
    
}
