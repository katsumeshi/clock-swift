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
    var cityTimes = Observable.just([AlarmSection(header: "aaaaa", cityTimes: [Alarm()])])
    private let bag = DisposeBag()
    private let dataStore: DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
//        let syncedTimer = syncTimerInterval(RxTimeInterval.seconds(60))
//                .flatMapLatest { [unowned self] (date) -> Observable<Date> in
//                    self.timerInterval(RxTimeInterval.seconds(1), date: date)
//                }
//
//        let cityTimes = dataStore.cityTimes
//
//        Observable.combineLatest(syncedTimer, cityTimes).subscribe { [unowned self] (date, cityTimes) in
//            let cities = cityTimes.map { cityTime in
//                CityTime(zone: cityTime.zone, date: date)
//            }
//            let model = CityTimeSection(header: "", cityTimes: cities)
//            self._cityTimes.accept([model])
//        }.disposed(by: bag)

    }
    
    func remove(indexPath: IndexPath) {
        dataStore.remove(index: indexPath.row)
    }
    
    func move(sourceIndex: IndexPath, destinationIndex: IndexPath) {
        dataStore.move(from: sourceIndex.row, to: destinationIndex.row)
    }
}
