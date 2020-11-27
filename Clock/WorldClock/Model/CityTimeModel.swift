//
//  CityTimeModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-26.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import SwiftDate

struct CityTimeSection {
    var cityTimes: [CityTime]
}

extension CityTimeSection: AnimatableSectionModelType {
    
    typealias Item = CityTime

    var identity: String {
        return ""
    }
    
    var items: [CityTime] {
        return cityTimes
    }

    init(original: CityTimeSection, items: [Item]) {
        self = original
        self.cityTimes = items
    }
}

struct CityTime: IdentifiableType, Equatable {
    
    var zone: Zones = Zones.gmt
    var date: Date = Date();
    var title: String {
        get {
            zone.getCity()
        }
    }
    var identity: String {
        return zone.rawValue
    }
    
    static func ==(lhs: CityTime, rhs: CityTime) -> Bool {
        return lhs.identity == rhs.identity
    }
}
