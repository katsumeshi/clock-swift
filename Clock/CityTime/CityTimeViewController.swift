//
//  ViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-14.
//

import UIKit
import RxSwift

class CityTimeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var cityTimeViewModel: CityTimeViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: bag)
            
        cityTimeViewModel.a
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "reuseIdentifier",
                                         cellType: CityTimeTableViewCell.self))
            { (row, cityTime, cell) in
                cell.timeZone = cityTime.zone
                cell.timeUpdate(date: cityTime.date)
                cell.updateCityName()
                cell.updateTimeDiff()
            }.disposed(by: bag)
    }
}

extension CityTimeViewController: UITableViewDelegate {}


