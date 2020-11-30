//
//  AlarmModal.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-29.
//

import UIKit
import RxDataSources
import RxSwift

struct AlarmSection {
    var header: String
    var cityTimes: [Alarm]
}

extension AlarmSection: AnimatableSectionModelType {
    
    typealias Item = Alarm

    var identity: String {
        return header
    }
    
    var items: [Alarm] {
        return cityTimes
    }

    init(original: AlarmSection, items: [Item]) {
        self = original
        self.cityTimes = items
    }
}

struct Alarm: IdentifiableType, Equatable {
    
    var date = Date()
    var isOn = false
    var identity: Date {
        return date
    }
    
    static func ==(lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.identity == rhs.identity
    }
}

