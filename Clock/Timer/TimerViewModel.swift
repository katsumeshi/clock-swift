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
    
    private static let interval = 0.1
    private let _lapTimers = BehaviorRelay<[LapModel]>(value: [])
    private let _timer = BehaviorRelay<Date>(value: Date(timeIntervalSince1970: 0))
    private let _timeState = BehaviorRelay<TimerState>(value: .stop)
    private let dispatchTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
    private var timeRemaining = Date(timeIntervalSince1970: 0)
    private var pickerTime = Date(timeIntervalSince1970: 0)
    
    var timer: Observable<String> {
        return _timer.map{ $0.toTimerFormat() }.asObservable()
    }
    
    var lapTimers: Observable<[LapModel]> {
        return _lapTimers.asObservable()
    }
    
    var isTimerHidden: Observable<Bool> {
        return _timeState.map { $0 == .stop }
    }
    
    var startPauseButtonTitle: Observable<String> {
        return _timeState.map { $0 == .start ? "Pause" : "Start" }
    }
    
    var isPickerHidden: Observable<Bool> {
        return _timeState.map { $0 != .stop }
    }
    
    init() {
        dispatchTimer.schedule(deadline: DispatchTime.now() + TimerViewModel.interval, repeating: TimerViewModel.interval)
        dispatchTimer.setEventHandler { [unowned self] in
            timeRemaining = timeRemaining - TimerViewModel.interval
            _timer.accept(timeRemaining)
        }
    }
    
    func toggleStartPause() {
        _timeState.value == .start ? pauseTimer() : startTimer()
//        _isStarting.value ? stopTimer() : startTimer()
//        _startButton.accept(_isStarting.value ? "Start" : "Pause")
//        _isStarting.accept(!_isStarting.value)
    }
    
    func updateTimer(hours: Int, min: Int, sec:Int ) {
        timeRemaining = Date(timeIntervalSince1970: 0)
        timeRemaining = timeRemaining + hours.hours
        timeRemaining = timeRemaining + min.minutes
        timeRemaining = timeRemaining + sec.seconds
        pickerTime = Date(timeIntervalSince1970: timeRemaining.timeIntervalSince1970)
    }
    
    func cancel() {
        cancelTimer()
    }
    
    private func startTimer() {
        _timeState.accept(.start)
        dispatchTimer.resume()
    }
    
    private func pauseTimer() {
        _timeState.accept(.pause)
        dispatchTimer.suspend()
    }
    
    private func cancelTimer() {
        timeRemaining = Date(timeIntervalSince1970: pickerTime.timeIntervalSince1970)
        if _timeState.value == .start {
            dispatchTimer.suspend()
        }
        _timeState.accept(.stop)
    }
    
}
