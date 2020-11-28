//
//  TimerViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-27.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var lap: UIButton!
    
    var viewModel: TimerViewModel = TimerViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        start.rx.tap.subscribe({ [unowned self] _ in
            viewModel.toggleStartStop()
        }).disposed(by: bag)
        
        lap.rx.tap.subscribe({ [unowned self] _ in
            viewModel.toggleLapReset()
        }).disposed(by: bag)
        
        viewModel.timer
            .bind(to: timer.rx.text)
            .disposed(by: bag)
        
        viewModel.startButton
            .bind(to: start.rx.title())
            .disposed(by: bag)
        
        viewModel.lapButton
            .bind(to: lap.rx.title())
            .disposed(by: bag)
    }
}
