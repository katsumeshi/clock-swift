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

struct StopwatchSection {
    var timers: [Stopwatch]
}

extension StopwatchSection: AnimatableSectionModelType {
    
    typealias Item = Stopwatch

    var identity: String {
        return ""
    }
    
    var items: [Stopwatch] {
        return timers
    }

    init(original: StopwatchSection, items: [Item]) {
        self = original
        self.timers = items
    }
}

struct Stopwatch: IdentifiableType, Equatable {
    
    var date: Date = Date();
    var identity: Date {
        return date
    }
    
    static func ==(lhs: Stopwatch, rhs: Stopwatch) -> Bool {
        return lhs.identity == rhs.identity
    }
}

