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
    @IBOutlet weak var editButton: UIBarButtonItem!
    var viewModel: CityTimeViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rx.setDelegate(self).disposed(by: bag)
    
        let dataSource = CityTimeViewController.dataSource()
        
        tableView.rx.itemDeleted
            .subscribe(onNext: { [unowned self] indexPath in
                self.viewModel.remove(indexPath: indexPath)
            })
            .disposed(by: bag)
        
        tableView.rx.itemMoved.subscribe({ [unowned self] item in
            guard let ele = item.element else { return }
            self.viewModel.move(sourceIndex: ele.sourceIndex, destinationIndex: ele.destinationIndex)
        })
        .disposed(by: bag)
        
        viewModel.cityTimes
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        editButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.tableView.isEditing = !self.tableView.isEditing
            self.tableView.reloadData()
        })
        .disposed(by: bag)
    }
}

extension CityTimeViewController: UITableViewDelegate {}


extension CityTimeViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<CityTimeSection> {
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { _, table, idxPath, item in
                let cell = table.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: idxPath)  as! CityTimeTableViewCell
                cell.timeZone = item.zone
                cell.timeUpdate(date: item.date, visible: !table.isEditing)
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
