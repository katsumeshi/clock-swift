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
            viewModel.toggleTimer()
        }).disposed(by: bag)
        
        viewModel.timer
            .bind(to: timer.rx.text)
            .disposed(by: bag)
    }
}
