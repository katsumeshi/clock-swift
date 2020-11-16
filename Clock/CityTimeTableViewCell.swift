//
//  CityTimeTableViewCell.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-14.
//

import UIKit
import Kronos
import RxSwift
import RxCocoa
import SwiftDate


class CityTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeDifference: UILabel!
    @IBOutlet weak var time: UILabel!
    let disposeBag = DisposeBag()
    let disposeBag2 = DisposeBag()
    
    func update() {
        
        func syncTimerInterval(_ interval: DispatchTimeInterval) -> Observable<Date> {
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
        
        func timerInterval(_ interval: DispatchTimeInterval, date: Date) -> Observable<Date> {
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
        
        
        syncTimerInterval(RxTimeInterval.seconds(60))
            .flatMapLatest { (date) -> Observable<Date> in
            timerInterval(RxTimeInterval.seconds(1), date: date)
        }.map {
            $0.toFormat("HH:mm")
        }.bind(to: self.time.rx.text).disposed(by: disposeBag)
    }
    
    
}

class CityTimeViewModel {
    
}
