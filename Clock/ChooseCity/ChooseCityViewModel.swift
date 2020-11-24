//
//  ChooseCityViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import RxSwift
import SwiftDate

struct City {
    var zone: Zones = Zones.gmt
    var title: String {
        get {
            zone.getCity()
        }
    }
}

class ChooseCityViewModel {
    
    var dataStore: DataStore!
    
    let timeZoneTitles = Observable.just(TimeZone.knownTimeZoneIdentifiers.map {
        City(zone: Zones(rawValue: $0) ?? Zones.gmt)
    })
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func addCity(city: City) {
        dataStore.add(city: city)
    }
}
