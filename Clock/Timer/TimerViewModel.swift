//
//  TimerViewModel.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-29.
//

import RxSwift
import RxCocoa
import SwiftDate

enum TimerState {
    case start, pause, stop
}

class TimerViewModel {
    
    private let _lapTimers = BehaviorRelay<[LapModel]>(value: [])
    private let _timer = BehaviorRelay<Date>(value: Date.init(timeIntervalSince1970: 0))
    private var startTime: Double = 0
    private var duration: Double = 0
    private static let interval = 1.0
    private let dispatchTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//    private var isStarting = false
    private let _startButton = BehaviorRelay<String>(value: "Start")
    private let _lapButton = BehaviorRelay<String>(value: "Lap")
    private let _timeState = BehaviorRelay<TimerState>(value: .stop)
    
    var timer: Observable<String> {
        return _timer.map{ $0.toTimerFormat() }.asObservable()
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
    
    var isTimerHidden: Observable<Bool> {
        return _timeState.map { $0 == .stop }
    }
    
    var isPickerHidden: Observable<Bool> {
        return _timeState.map { $0 != .stop }
    }
    
    init() {
        dispatchTimer.schedule(deadline: DispatchTime.now() + TimerViewModel.interval, repeating: TimerViewModel.interval)
        dispatchTimer.setEventHandler { [unowned self] in
            let time = Date().timeIntervalSinceReferenceDate - startTime + duration
            let date = Date.init(timeIntervalSinceReferenceDate: time)
            _timer.accept(date)
        }
    }
    
    func toggleStartPause() {
        _timeState.value == .stop ? pauseTimer() : startTimer()
//        _isStarting.value ? stopTimer() : startTimer()
//        _startButton.accept(_isStarting.value ? "Start" : "Pause")
//        _isStarting.accept(!_isStarting.value)
    }
    
    func cancel() {
        stopTimer()
    }
    
    private func startTimer() {
        _timeState.accept(.start)
//        startTime = Date().timeIntervalSince1970
//        dispatchTimer.resume()
    }
    
    private func pauseTimer() {
        _timeState.accept(.pause)
//        duration += Date().timeIntervalSince1970 - startTime
//        dispatchTimer.suspend()
    }
    
    private func stopTimer() {
        _timeState.accept(.stop)
//        duration += Date().timeIntervalSince1970 - startTime
//        dispatchTimer.suspend()
    }
    
    func toggleLapReset() {
//        _isStarting.value ? lapTimer() : restTimer()
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
