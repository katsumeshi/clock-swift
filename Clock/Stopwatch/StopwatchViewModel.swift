//
//  TimerViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-27.
//

import RxSwift
import RxCocoa
import SwiftDate

struct LapModel {
    var prevTime: Date = Date.init(timeIntervalSince1970: 0)
    var currentTime: Date = Date.init(timeIntervalSince1970: 0)
    var count: Int = 0
}

class StopwatchViewModel {
    
    private let _lapTimers = BehaviorRelay<[LapModel]>(value: [])
    private let _timer = BehaviorRelay<Date>(value: Date.init(timeIntervalSince1970: 0))
    private var startTime: Double = 0
    private var duration: Double = 0
    private static let interval = 0.05
    private let dispatchTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    private var isStarting = false
    private let _startButton = BehaviorRelay<String>(value: "Start")
    private let _lapButton = BehaviorRelay<String>(value: "Lap")
    
    var timer: Observable<String> {
        return _timer.map{ $0.toStopwatchFormat() }.asObservable()
    }
    
    var startButton: Observable<String> {
        return _startButton.asObservable()
    }
    
    var lapButton: Observable<String> {
        return _lapButton.asObservable()
    }
    
    var lapTimers: Observable<[LapModel]> {
        return _lapTimers.asObservable()
    }
    
    init() {
        dispatchTimer.schedule(deadline: DispatchTime.now() + StopwatchViewModel.interval, repeating: StopwatchViewModel.interval)
        dispatchTimer.setEventHandler { [unowned self] in
            let time = Date().timeIntervalSinceReferenceDate - startTime + duration
            let date = Date.init(timeIntervalSinceReferenceDate: time)
            _timer.accept(date)
        }
    }
    
    func toggleStartStop() {
        isStarting ? stopTimer() : startTimer()
        _startButton.accept(isStarting ? "Start" : "Stop")
        _lapButton.accept(isStarting ? "Reset" : "Lap")
        isStarting = !isStarting
    }
    
    private func startTimer() {
        startTime = Date().timeIntervalSince1970
        dispatchTimer.resume()
    }
    
    private func stopTimer() {
        duration += Date().timeIntervalSince1970 - startTime
        dispatchTimer.suspend()
    }
    
    func toggleLapReset() {
        isStarting ? lapTimer() : restTimer()
    }
    
    private func lapTimer() {
        let current = _lapTimers.value.first?.currentTime ?? Date.init(timeIntervalSince1970: 0)
        let lap = LapModel(prevTime: current, currentTime: _timer.value,  count: _lapTimers.value.count)
        _lapTimers.accept([lap] + _lapTimers.value)
    }
    
    private func restTimer() {
        duration = 0.0
        _lapButton.accept("Lap")
        _timer.accept(Date.init(timeIntervalSince1970: 0))
        _lapTimers.accept([])
    }
    
}

extension Date {
    func toStopwatchFormat() -> String {
        return self.toFormat("mm:ss.SS")
    }
    
    func toTimerFormat() -> String {
        return self.toFormat("HH:mm:ss")
    }
}
