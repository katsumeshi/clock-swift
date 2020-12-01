//
//  AlarmViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-29.
//

import RxSwift
import RxCocoa
import SwiftDate
import Kronos

class AlarmViewModel {
    
    private let _cityTimes = BehaviorRelay<[CityTimeSection]>(value: [])
    var cityTimes = Observable.just([AlarmSection(header: "", cityTimes: [Alarm()])])
    private let bag = DisposeBag()
    private let dataStore: DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func remove(indexPath: IndexPath) {
        dataStore.remove(index: indexPath.row)
    }
    
    func move(sourceIndex: IndexPath, destinationIndex: IndexPath) {
        dataStore.move(from: sourceIndex.row, to: destinationIndex.row)
    }
}
