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
    @IBOutlet private weak var searchBar: UISearchBar!
    
    var viewModel: ChooseCityViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.rx.setDelegate(self).disposed(by: bag)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<CityTimeSection> (
                            configureCell: { _, table, idxPath, item in
                                let cell = table.dequeueReusableCell(withIdentifier: "ChooseCityTableViewCell", for: idxPath)  as! ChooseCityTableViewCell
                                cell.title.text = item.title
                                return cell
                            },
                            titleForHeaderInSection: { ds, index in
                                return ds.sectionModels[index].header
                            },
                            sectionIndexTitles: { [unowned self] item in
                                if searchBar.text?.count ?? 0 == 0 {
                                    return ChooseCityViewModel.titles
                                }
                                return []
                            },
                            sectionForSectionIndexTitle: { table, title, index  in
                                return ChooseCityViewModel.titles.firstIndex(of: title) ?? 0
                            }
                        )
        
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
        
        searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [unowned self] query in
                viewModel.search(query: query)
            })
            .disposed(by: bag)
        
        
        let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton
        cancelButton?.isEnabled = true
        
        cancelButton?.rx.tap.subscribe(onNext: { [unowned self] in
            self.dismiss(animated: true)
        })
        .disposed(by: bag)
        
    }
}

extension ChooseCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

extension ChooseCityViewController: UITableViewDelegate {}
