//
//  ChooseCityViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class ChooseCityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ChooseCityViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        let dataSource = ChooseCityViewController.dataSource()
        
        viewModel.cityTimes
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.modelSelected(CityTime.self)
            .subscribe(onNext: { [unowned self] cityTime in
                viewModel.addCityTime(cityTime: cityTime)
                self.dismiss(animated: true)
            })
            .disposed(by: bag)
    }
}

extension ChooseCityViewController: UITableViewDelegate {}

private extension ChooseCityViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<CityTimeSection> {
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { _, table, idxPath, item in
                let cell = table.dequeueReusableCell(withIdentifier: "ChooseCityTableViewCell", for: idxPath)  as! ChooseCityTableViewCell
                cell.title.text = item.title
                return cell
            },
            sectionIndexTitles: { item in
                return ChooseCityViewModel.titles
            },
            sectionForSectionIndexTitle: { _,_,_  in
                return 0
            }
        )
    }
}
