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

class CityTime {
    var timeZone: Zones
    var date: Date = Date();
    
    init(date: Date, timeZone: Zones) {
        self.date = date
        self.timeZone = timeZone
    }
    
    init(timeZone: Zones) {
        self.timeZone = timeZone
    }
}

class CityTimeViewModel {
    
    private var timeZones = BehaviorRelay<[CityTime]>(value: [])
    var a: Observable<[CityTime]> {
        return timeZones.asObservable()
    }
    private let bag = DisposeBag()
    
    init(dataStore: DataStore) {
        
        let b = syncTimerInterval(RxTimeInterval.seconds(60))
                .flatMapLatest { (date) -> Observable<Date> in
                    self.timerInterval(RxTimeInterval.seconds(1), date: date)
                }
        
        let c = dataStore.timezones
        
        Observable.combineLatest(b, c).subscribe { (d, g) in
            self.timeZones.accept(  g.map { gg in
                CityTime(date: d, timeZone: gg.zone)
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
