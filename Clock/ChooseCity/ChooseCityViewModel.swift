//
//  ChooseCityViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import RxSwift
import SwiftDate

struct CityTime: Hashable {
    var zone: Zones = Zones.gmt
    var date: Date = Date();
    var title: String {
        get {
            zone.getCity()
        }
    }
    static func ==(lhs: CityTime, rhs: CityTime) -> Bool {
        return lhs.zone == rhs.zone
    }
}

class ChooseCityViewModel {
    
    var dataStore: DataStore!
    
    let timeZoneTitles = Observable.just(TimeZone.knownTimeZoneIdentifiers.map {
        CityTime(zone: Zones(rawValue: $0) ?? Zones.gmt)
    })
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func addCityTime(cityTime: CityTime) {
        dataStore.add(cityTime: cityTime)
    }
}
