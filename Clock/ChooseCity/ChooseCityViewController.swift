//
//  ChooseCityViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import UIKit
import RxSwift

class ChooseCityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var chooseCityViewModel = ChooseCityViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        chooseCityViewModel
            .timeZoneTitles
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "reuseIdentifier", cellType: ChooseCityTableViewCell.self)) { (row, title, cell) in
                cell.title.text = title
            }.disposed(by: bag)
        
//        cityTimeViewModel
//            .timeZones
//            .observe(on: MainScheduler.instance)
//            .bind(to: tableView.rx.items(cellIdentifier: "reuseIdentifier", cellType: CityTimeTableViewCell.self)) { (row, timeZone, cell) in
//
//                cell.timeZone = timeZone
//                cell.updateCityName()
//                cell.updateTimeDiff()
//
//                self.cityTimeViewModel.startClock()
//                    .observe(on: MainScheduler.instance)
//                    .subscribe { date in
//                        cell.timeUpdate(date :date)
//                    }.disposed(by: self.bag)
//            }.disposed(by: bag)
//
//        cityTimeViewModel.setup()
    }
}

extension ChooseCityViewController: UITableViewDelegate {}
