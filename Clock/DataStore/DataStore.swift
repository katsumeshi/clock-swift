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
    private var _cityTimes = BehaviorRelay<Set<CityTime>>(value: [])
    var cityTimes: Observable<Set<CityTime>> {
        return _cityTimes.asObservable()
    }
    
    func add(cityTime: CityTime) {
        var value = Array(_cityTimes.value)
        value.append(cityTime)
        _cityTimes.accept(Set(value))
    }
    
    func remove(cityTime: CityTime) {
        var val = _cityTimes.value
        val.remove(cityTime)
        _cityTimes.accept(val)
    }
    
}
