//
//  dataStore.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-22.
//

import Foundation
import RxCocoa
import RxSwift

final class DataStore {
    private var _cityTimes = BehaviorRelay<[CityTime]>(value: [])
    var cityTimes: Observable<[CityTime]> {
        return _cityTimes.asObservable()
    }
    
    func add(cityTime: CityTime) {
        var value = _cityTimes.value
        if !value.contains(cityTime) {
            value.append(cityTime)
        }
        _cityTimes.accept(value)
    }
    
    func remove(index: Int) {
        var val = _cityTimes.value
        val.remove(at: index)
        _cityTimes.accept(val)
    }
    
    func move(from: Int, to: Int) {
        var cities = _cityTimes.value
        let insertCity = cities[from]
        cities.remove(at: from)
        cities.insert(insertCity, at: to)
        _cityTimes.accept(cities)
    }
    
}
