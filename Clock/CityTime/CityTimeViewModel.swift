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
    
    private var timeZones = BehaviorRelay<[CityTime]>(value: [])
    var a: Observable<[CityTime]> {
        return timeZones.asObservable()
    }
    private let bag = DisposeBag()
    
    init(dataStore: DataStore) {
        
        let syncedTimer = syncTimerInterval(RxTimeInterval.seconds(60))
                .flatMapLatest { [unowned self] (date) -> Observable<Date> in
                    self.timerInterval(RxTimeInterval.seconds(1), date: date)
                }
        
        let cityTimes = dataStore.cityTimes
        
        Observable.combineLatest(syncedTimer, cityTimes).subscribe { [unowned self] (date, cityTimes) in
            self.timeZones.accept( cityTimes.map { cityTime in
                CityTime(zone: cityTime.zone, date: date)
            })
        }.disposed(by: bag)

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
