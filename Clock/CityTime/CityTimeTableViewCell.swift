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
    private let disposeBag = DisposeBag()
    var timeZone = Zones.gmt
    
    func timeUpdate(date: Date) {
        
        time.text = dateInRegion(date: date).toFormat("HH:mm")
    }
    
    func updateCityName() {
        if let city = timeZone.rawValue.split(separator: "/").last {
            cityName.text = "\(city.replacingOccurrences(of: "_", with: " "))"
        }
    }
    
    func updateTimeDiff() {
        let date = Date()
        let convertedDate = date.convertToTimeZone(timeZone:  timeZone.toTimezone())
        if let diff = (convertedDate - date).hour {
            timeDifference.text = "+\(diff)HRS"
        }
    }
    
    func dateInRegion(date: Date) -> DateInRegion {
        let region = Region(calendar: Calendars.gregorian, zone: timeZone, locale: Locales.english)
        return date.convertTo(region: region)
    }
    
}

extension Date {
    func convertToTimeZone(timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - TimeZone.current.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
