//
//  CityTimeViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-15.
//

import RxSwift
import RxCocoa
import SwiftDate
import Kronos

class CityTimeViewModel {
    
    private let _cityTimes = BehaviorRelay<[SampleSectionModel]>(value: [])
    var cityTimes: Observable<[SampleSectionModel]> {
        return _cityTimes.asObservable()
    }
    private let bag = DisposeBag()
    private let dataStore: DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
        let syncedTimer = syncTimerInterval(RxTimeInterval.seconds(60))
                .flatMapLatest { [unowned self] (date) -> Observable<Date> in
                    self.timerInterval(RxTimeInterval.seconds(1), date: date)
                }
        
        let cityTimes = dataStore.cityTimes
        
        Observable.combineLatest(syncedTimer, cityTimes).subscribe { [unowned self] (date, cityTimes) in
            let cities = cityTimes.map { cityTime in
                CityTime(identity: cityTime.identity, date: date)
            }
            let model = SampleSectionModel(model: .section1, items: cities)
            self._cityTimes.accept([model])
        }.disposed(by: bag)

    }
    
    func remove(indexPath: IndexPath) {
//        guard let item = _cityTimes.value.first?.items[] else { return }
        dataStore.remove(index: indexPath.row)
    }
    
    func move(sourceIndex: IndexPath, destinationIndex: IndexPath) {
//        guard let item = _cityTimes.value.first?.items[sourceIndex.row] else { return }
        dataStore.move(from: sourceIndex.row, to: destinationIndex.row)
    }
}


private extension CityTimeViewModel {
    
    private func syncTimerInterval(_ interval: DispatchTimeInterval) -> Observable<Date> {
        return Observable.create { observer in
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
            
            let cancel = Disposables.create { timer.cancel() }
            
            observer.onNext(Date())
            
            Clock.sync(completion:  { date, offset in
                if let date = date  {
                    observer.onNext(date)
                }
            })
            
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                Clock.sync(completion:  { date, offset in
                    if let date = date  {
                        observer.onNext(date)
                    }
                })
            }
            timer.resume()
            return cancel
        }
    }
    
    private func timerInterval(_ interval: DispatchTimeInterval, date: Date) -> Observable<Date> {
        return Observable.create { observer in
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
            
            let cancel = Disposables.create {
                timer.cancel()
                
            }
            
            var newDate = date
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                newDate = newDate + 1.seconds
                observer.onNext(newDate)
            }
            timer.resume()
            return cancel
        }
    }
}
