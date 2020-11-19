//
//  ChooseCityTableViewCell.swift
//  Clock
//
//  Created by katsumeshi on 2020-11-18.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftDate

class ChooseCityTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
//    private let disposeBag = DisposeBag()
//    var timeZone = Zones.gmt
    
//    func timeUpdate(date: Date) {
//        time.text = getDateInRegion(date: date).toFormat("HH:mm")
//    }
//
//    func updateCityName() {
//        if let city = timeZone.rawValue.split(separator: "/").last {
//            cityName.text = "\(city.replacingOccurrences(of: "_", with: " "))"
//        }
//    }
//
//    func updateTimeDiff() {
//        let currentDate = DateInRegion(Date(), region: Region.current)
//
//        let tDiff = timeDiff(date: currentDate.date)
//        let dDiff = dateDiff(date: currentDate + tDiff.hours)
//
//        timeDifference.text = "\(dDiff) +\(tDiff)HRS"
//    }
}
