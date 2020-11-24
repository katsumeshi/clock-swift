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
    private var timezone = BehaviorRelay<[City]>(value: [])
    
    var timezones: Observable<[City]> {
        return timezone.asObservable()
    }
    
    func add(city: City) {
        timezone.accept(timezone.value + [city])
    }
}
