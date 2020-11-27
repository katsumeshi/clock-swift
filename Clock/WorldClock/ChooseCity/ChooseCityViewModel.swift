//
//  ChooseCityViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import RxSwift
import RxDataSources
import SwiftDate
import RxCocoa

class ChooseCityViewModel {
    
    var dataStore: DataStore!
    static let cityTimes = TimeZone.knownTimeZoneIdentifiers.map {
        CityTime(zone: Zones(rawValue: $0) ?? Zones.gmt)
    }.sorted { $0.title < $1.title }
    
    static let titles = Array(Set(cityTimes.map {
        $0.title.first?.uppercased() ?? ""
    }).sorted())
    
    static let cityTimeSection: [CityTimeSection] = titles.map { initial in
        let items = cityTimes.filter { $0.title.prefix(1) == initial }
        return CityTimeSection(header: initial, cityTimes: items)
    }
    
    private let _cityTimes = BehaviorRelay<[CityTimeSection]>(value: [])
    var cityTimes: Observable<[CityTimeSection]> {
        return _cityTimes.asObservable()
    }
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
        let items = ChooseCityViewModel.cityTimeSection
        _cityTimes.accept(items)
    }
    
    func addCityTime(cityTime: CityTime) {
        dataStore.add(cityTime: cityTime)
    }
}
