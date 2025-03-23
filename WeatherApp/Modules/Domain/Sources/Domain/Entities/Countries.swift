//
//  Countries.swift
//  Domain
//
//  Created by Deiner Calbang on 3/23/25.
//

import Foundation

public struct Country: Codable, Identifiable {
    public let id = UUID()
    public let country: String
    public let city: String?
}
