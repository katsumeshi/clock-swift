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

class StopwatchViewController: UIViewController {
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var lap: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    private let viewModel = StopwatchViewModel()
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
        
        viewModel.lapTimers
            .bind(to: tableView.rx.items(cellIdentifier: "TimerTableViewCell", cellType: TimerTableViewCell.self)) { row, element, cell in
                let time = element.currentTime.timeIntervalSince1970 - element.prevTime.timeIntervalSince1970
                cell.title.text = "Lap \(element.count)"
                cell.lap.text = Date.init(timeIntervalSince1970: time).toTimerFormat()
            }
            .disposed(by: bag)
    }
}
