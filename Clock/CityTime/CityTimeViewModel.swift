//
//  CityTimeViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-15.
//

import RxSwift
import SwiftDate
import Kronos

class CityTimeViewModel {
    
    public let timeZones : PublishSubject<[Zones]> = PublishSubject()
    
    
    func setup() {
        timeZones.onNext([Zones.americaLosAngeles, Zones.asiaTokyo])
        timeZones.onCompleted()
    }
    
    
    func startTimer() -> Observable<Date> {
        
        
        return syncTimerInterval(RxTimeInterval.seconds(60))
            .flatMapLatest { (date) -> Observable<Date> in
                self.timerInterval(RxTimeInterval.seconds(1), date: date)
            }
        
        //            .map {
        //                let dateInRome = $0.convertTo(region: london)
        //                return dateInRome.toFormat("HH:mm")
        //            }
        //            .bind(to: self.time.rx.text).disposed(by: disposeBag)
    }
    
    //    func a() {
    //        let timeZoneIdentifiers = TimeZone.knownTimeZoneIdentifiers
    //        let allCities = timeZoneIdentifiers.compactMap { identifier in
    //            return identifier.split(separator: "/").last
    //        }
    //    }
}


extension CityTimeViewModel {
    
    private func syncTimerInterval(_ interval: DispatchTimeInterval) -> Observable<Date> {
        return Observable.create { observer in
            print("Subscribed")
            let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            timer.schedule(deadline: DispatchTime.now() + interval, repeating: interval)
            
            let cancel = Disposables.create { timer.cancel() }
            
            observer.on(.next(Date()))
            
            Clock.sync(completion:  { date, offset in
                if let date = date  {
                    observer.on(.next(date))
                }
            })
            
            timer.setEventHandler {
                if cancel.isDisposed {
                    return
                }
                Clock.sync(completion:  { date, offset in
                    if let date = date  {
                        observer.on(.next(date))
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
                observer.on(.next(newDate))
            }
            timer.resume()
            return cancel
        }
    }
}
