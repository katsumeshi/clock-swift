//
//  ChooseCityViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import RxSwift
import SwiftDate

class ChooseCityViewModel {
    
//    public let timeZones : PublishSubject<[Zones]> = PublishSubject()
    
    let timeZoneTitles = Observable.just(TimeZone.knownTimeZoneIdentifiers.map {
//        "\($0.split(separator: "/").last ?? "")".replace
        Zones(rawValue: $0)?.getCity()
    }.filter { ($0?.count ?? 0) > 0 })
    
    
    func setup() {
//        timeZones.onNext([Zones.americaLosAngeles,
//                          Zones.asiaTokyo,
//                          Zones.americaNorthDakotaBeulah,
//                          Zones.americaVancouver,
//                          Zones.americaOjinaga])
//        timeZones.onCompleted()
    }
    
    
//    func startClock() -> Observable<Date> {
//        return syncTimerInterval(RxTimeInterval.seconds(60))
//            .flatMapLatest { (date) -> Observable<Date> in
//                self.timerInterval(RxTimeInterval.seconds(1), date: date)
//            }
//    }
}
