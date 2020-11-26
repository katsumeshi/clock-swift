//
//  ViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-14.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class CityTimeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CityTimeViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: bag)
    
        let dataSource = CityTimeViewController.dataSource()
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel.remove(indexPath: indexPath)
            })
            .disposed(by: bag)
        
        viewModel.cityTimes
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
}

extension CityTimeViewController: UITableViewDelegate {}

enum SectionID: String, IdentifiableType {
    case section1

    var identity: String {
        return self.rawValue
    }
}
typealias SampleSectionModel = AnimatableSectionModel<SectionID, CityTime>

extension CityTimeViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<SampleSectionModel> {
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { _, table, idxPath, item in
                let cell = table.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: idxPath)  as! CityTimeTableViewCell
                cell.timeZone = item.identity
                cell.timeUpdate(date: item.date)
                cell.updateCityName()
                cell.updateTimeDiff()
                return cell
            },
            canEditRowAtIndexPath: { _, _ in
                return true
            },
            canMoveRowAtIndexPath: { _, _ in
                return true
            }
        )
    }
}
