//
//  UsageStat.swift
//  FruitsApp
//
//  Created by Rohit on 18/12/2021.
//

import Foundation

enum UsageEventType: String, Codable {
    case load
    case display
    case error
}

struct UsageStat:Codable {
    let event: UsageEventType
    let data: String
}
