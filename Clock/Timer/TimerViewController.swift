//
//  TimerViewController.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-28.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa



class TimerViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timerView: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    private let viewModel = TimerViewModel()
    private let bag = DisposeBag()
    
    private let items = Observable.just([Array(0...23),
                                         Array(0...59),
                                         Array(0...59)])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = items.bind(to: pickerView.rx.items(adapter: PickerViewViewAdapter()))
        
        startPauseButton.rx.tap.subscribe { [unowned self] _ in
            viewModel.toggleStartPause()
        }.disposed(by: bag)
        
        cancelButton.rx.tap.subscribe { [unowned self] _ in
            viewModel.cancel()
        }.disposed(by: bag)
        
        viewModel.isTimerHidden
            .bind(to: timerView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.isPickerHidden
            .bind(to: pickerView.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.timer
            .bind(to: timerView.rx.text)
            .disposed(by: bag)
        
    }
}

final class PickerViewViewAdapter
    : NSObject
    , UIPickerViewDataSource
    , UIPickerViewDelegate
    , RxPickerViewDataSourceType
    , SectionedViewDataSourceType {
    typealias Element = [[Int]]
    private var items: [[Int]] = []

    func model(at indexPath: IndexPath) throws -> Any {
        items[indexPath.section][indexPath.row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        6
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
            case 0:
                return 24;
            case 2, 4:
                return 60;
            default:
                return 1;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        guard items.count > 0  else { return label }
        switch (component) {
            case 0:
                label.text = items[0][row].description
            case 1:
                label.text = "hours"
            case 2:
                label.text = items[1][row].description
            case 3:
                label.text = "min"
            case 4:
                label.text = items[2][row].description
            case 5:
                label.text = "sec"
            default:
                break
        }
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
        Binder(self) { (adapter, items) in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
