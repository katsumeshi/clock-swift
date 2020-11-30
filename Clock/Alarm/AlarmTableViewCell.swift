//
//  AlarmTableViewCell.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-29.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftDate


class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var ampm: UILabel!
    private let disposeBag = DisposeBag()
}
