//
//  CityTimeTableViewCell.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-14.
//

import UIKit
import Kronos
import RxSwift
import RxCocoa
import SwiftDate


class CityTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeDifference: UILabel!
    @IBOutlet weak var time: UILabel!
    let disposeBag = DisposeBag()
    
    func timeUpdate(date: Date, timeZone: Zones) {
        let resion = Region(calendar: Calendars.gregorian, zone: timeZone, locale: Locales.english)
        let dateInReasion = date.convertTo(region: resion)
        time.text =  dateInReasion.toFormat("HH:mm")
    }
    
}
