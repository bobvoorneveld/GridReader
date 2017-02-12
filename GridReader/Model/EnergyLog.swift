//
//  EnergyLog.swift
//  GridReader
//
//  Created by Bob Voorneveld on 11/02/2017.
//  Copyright © 2017 Purple Gorilla. All rights reserved.
//

import Foundation

public struct EnergyLog {
    let produced: Int
    let consumed: Int
    let timestamp: Int
}

extension EnergyLog {
    init?(_ json: [String: Any]) {
        self.produced = json["produced"] as! Int
        self.consumed = json["consumed"] as! Int
        self.timestamp = json["timestamp"] as! Int
    }
}

extension EnergyLog {
    static func all(for household: Household) -> Resource<[EnergyLog]> {
        return Resource<[EnergyLog]>(path: "households/\(household.address)/logs") { jsonData in
            guard let jsonArray = jsonData as? [[String: Any]] else { return nil }
            return jsonArray.flatMap(EnergyLog.init)
        }
    }
}
