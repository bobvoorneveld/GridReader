//
//  Household.swift
//  GridReader
//
//  Created by Bob Voorneveld on 11/02/2017.
//  Copyright © 2017 Purple Gorilla. All rights reserved.
//

import Foundation


public struct Household {
    let address: String
}

extension Household {
    init?(_ address: String) {
        self.address = address
    }
}

public extension Household {
    static let all = Resource<[Household]>(path: "households", parseJSON: { json in
        guard let households = json as? [String] else { return nil }
        return households.flatMap(Household.init)
    })

    mutating func allLogs() -> Resource<[EnergyLog]> {
        return Resource<[EnergyLog]>(path: "households/\(address)/logs") { jsonData in
            guard let jsonArray = jsonData as? [[String: Any]] else { return nil }
            return jsonArray.flatMap(EnergyLog.init)
        }
    }

}
