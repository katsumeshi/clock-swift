//
//  dataStore.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-22.
//

import Foundation

final class DataStore {
    private var timezone: [City] = []
    
    func get() -> [City] {
        return timezone
    }
    
    func add(city: City) {
        timezone.append(city)
    }
}
