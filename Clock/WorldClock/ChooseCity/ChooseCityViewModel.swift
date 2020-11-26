//
//  ChooseCityViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import RxSwift
import RxDataSources
import SwiftDate

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
