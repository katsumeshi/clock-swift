//
//  TimerViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-27.
//

import RxSwift
import RxCocoa
import SwiftDate

class TimerViewModel {
    
    private let _timer = BehaviorRelay<String>(value: "00:00.00")
    private var startTime: Double = 0
    private var duration: Double = 0
    private static let interval = 0.05
    private let dispatchTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    private var isStarting = false
    
    var timer: Observable<String> {
        return _timer.asObservable()
    }
    
    init() {
        dispatchTimer.schedule(deadline: DispatchTime.now() + TimerViewModel.interval, repeating: TimerViewModel.interval)
        dispatchTimer.setEventHandler { [unowned self] in
            let time = Date().timeIntervalSinceReferenceDate - startTime + duration
            let date = Date.init(timeIntervalSinceReferenceDate: time)
            _timer.accept(date.toFormat("mm:ss.SS"))
        }
    }
    
    func toggleTimer() {
        if isStarting {
            stopTimer()
        } else {
            startTimer()
        }
        isStarting = !isStarting
    }
    
    private func startTimer() {
        startTime = Date().timeIntervalSinceReferenceDate
        dispatchTimer.resume()
    }
    
    private func stopTimer() {
        duration += Date().timeIntervalSinceReferenceDate - startTime
        dispatchTimer.suspend()
    }
    
}
