//
//  CityTimeViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-15.
//

import RxSwift
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
    
    let timeZones : PublishSubject<[CityTime]> = PublishSubject()
    var a: [CityTime] = [
        CityTime(timeZone: Zones.americaLosAngeles),
        CityTime(timeZone: Zones.asiaTokyo),
        CityTime(timeZone: Zones.americaNorthDakotaBeulah),
        CityTime(timeZone: Zones.americaVancouver),
        CityTime(timeZone: Zones.americaOjinaga)
    ]
    
    init(dataStore: DataStore) {
        a = dataStore.get().map {
            CityTime(timeZone: $0.zone)
        }
    }
    
    
    func startClock() -> Observable<[CityTime]> {
        return syncTimerInterval(RxTimeInterval.seconds(60))
                .flatMapLatest { (date) -> Observable<Date> in
                    self.timerInterval(RxTimeInterval.seconds(1), date: date)
                }.map { date in
                    self.a.map { CityTime(date: date, timeZone: $0.timeZone) }
                }
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
