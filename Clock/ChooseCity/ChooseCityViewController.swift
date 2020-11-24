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
    var chooseCityViewModel: ChooseCityViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        chooseCityViewModel
            .timeZoneTitles
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "reuseIdentifier", cellType: ChooseCityTableViewCell.self)) { (row, city, cell) in
                cell.title.text = city.title
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(City.self)
            .subscribe(onNext: { [unowned self] city in
                chooseCityViewModel.addCity(city: city)
                self.dismiss(animated: true)
            })
            .disposed(by: bag)
    }
}

extension ChooseCityViewController: UITableViewDelegate {}
