//
//  AlarmViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-29.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa

class AlarmTableViewController: UITableViewController {
    var viewModel: AlarmViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = AlarmTableViewController.dataSource()
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        tableView.rx.setDelegate(self).disposed(by: bag)
//
//        tableView.rx.itemDeleted
//            .subscribe(onNext: { [unowned self] indexPath in
//                self.viewModel.remove(indexPath: indexPath)
//            })
//            .disposed(by: bag)
//
//        tableView.rx.itemMoved.subscribe({ [unowned self] item in
//            guard let ele = item.element else { return }
//            self.viewModel.move(sourceIndex: ele.sourceIndex, destinationIndex: ele.destinationIndex)
//        })
//        .disposed(by: bag)
//
        viewModel.cityTimes
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
//
//        editButton.rx.tap.subscribe(onNext: { [unowned self] in
//            self.tableView.isEditing = !self.tableView.isEditing
//            self.tableView.reloadData()
//        })
//        .disposed(by: bag)
        
    }
}

private extension AlarmTableViewController {
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<AlarmSection> {
        return RxTableViewSectionedAnimatedDataSource(
            configureCell: { _, table, idxPath, item in
                let cell = table.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: idxPath)  as! AlarmTableViewCell
                cell.time.text = item.date.toFormat("HH:mm")
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
