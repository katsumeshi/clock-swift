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
    private let _startButton = BehaviorRelay<String>(value: "Start")
    private let _lapButton = BehaviorRelay<String>(value: "Lap")
    
    var timer: Observable<String> {
        return _timer.asObservable()
    }
    
    var startButton: Observable<String> {
        return _startButton.asObservable()
    }
    
    var lapButton: Observable<String> {
        return _lapButton.asObservable()
    }
    
    init() {
        dispatchTimer.schedule(deadline: DispatchTime.now() + TimerViewModel.interval, repeating: TimerViewModel.interval)
        dispatchTimer.setEventHandler { [unowned self] in
            let time = Date().timeIntervalSinceReferenceDate - startTime + duration
            let date = Date.init(timeIntervalSinceReferenceDate: time)
            _timer.accept(date.toFormat("mm:ss.SS"))
        }
    }
    
    func toggleStartStop() {
        isStarting ? stopTimer() : startTimer()
        _startButton.accept(isStarting ? "Start" : "Stop")
        _lapButton.accept(isStarting ? "Reset" : "Lap")
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
    
    func toggleLapReset() {
        isStarting ? lapTimer() : restTimer()
    }
    
    private func lapTimer() {
        print("ppppp")
    }
    
    private func restTimer() {
        duration = 0.0
        _lapButton.accept("Lap")
        _timer.accept("00:00.00")
    }
    
}
