//
//  ChooseCityViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import RxSwift
import SwiftDate
import RxDataSources

extension Zones : IdentifiableType {
    public typealias Identity = Zones

    public var identity: Zones {
        return self
    }
}

struct CityTime: IdentifiableType, Hashable, Equatable {
    
    var identity: Zones = Zones.gmt
    var date: Date = Date();
    var title: String {
        get {
            identity.getCity()
        }
    }
    
    static func ==(lhs: CityTime, rhs: CityTime) -> Bool {
        return lhs.identity == rhs.identity
    }
    func hash(into hasher: inout Hasher) { }
}

class ChooseCityViewModel {
    
    var dataStore: DataStore!
    
    let timeZoneTitles = Observable.just(TimeZone.knownTimeZoneIdentifiers.map {
        CityTime(identity: Zones(rawValue: $0) ?? Zones.gmt)
    })
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func addCityTime(cityTime: CityTime) {
        dataStore.add(cityTime: cityTime)
    }
}
