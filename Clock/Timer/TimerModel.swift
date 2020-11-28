//
//  TimerModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-27.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import SwiftDate

struct TimerSection {
    var timers: [Timer]
}

extension TimerSection: AnimatableSectionModelType {
    
    typealias Item = Timer

    var identity: String {
        return ""
    }
    
    var items: [Timer] {
        return timers
    }

    init(original: TimerSection, items: [Item]) {
        self = original
        self.timers = items
    }
}

struct Timer: IdentifiableType, Equatable {
    
    var date: Date = Date();
    var identity: Date {
        return date
    }
    
    static func ==(lhs: Timer, rhs: Timer) -> Bool {
        return lhs.identity == rhs.identity
    }
}

