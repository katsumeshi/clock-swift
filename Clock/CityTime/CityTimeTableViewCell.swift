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
        time.text = getDateInRegion(date: date).toFormat("HH:mm")
    }
    
    func updateCityName() {
        cityName.text = timeZone.getCity()
    }
    
    func updateTimeDiff() {
        let currentDate = DateInRegion(Date(), region: Region.current)
        
        let tDiff = timeDiff(date: currentDate.date)
        let dDiff = dateDiff(date: currentDate + tDiff.hours)
        
        timeDifference.text = "\(dDiff) +\(tDiff)HRS"
    }
}

private extension CityTimeTableViewCell {
    
    private func getDateInRegion(date: Date) -> DateInRegion {
        let region = Region(calendar: Calendars.gregorian, zone: timeZone, locale: Locales.english)
        return date.convertTo(region: region)
    }
    
    private func timeDiff(date: Date) -> Int {
        let targetDate = date.convertToTimeZone(timeZone: timeZone.toTimezone())
        return (targetDate - date).hour ?? 0
    }
    
    private func dateDiff(date: DateInRegion) -> String {
        if date.compare(.isToday) {
            return "Today"
        } else if date.compare(.isTomorrow) {
            return "Tomorrow"
        } else if date.compare(.isYesterday) {
            return "Yesterday"
        }
        return ""
    }
}

extension Zones {
    func getCity() -> String {
        if let city = self.rawValue.split(separator: "/").last {
            return "\(city.replacingOccurrences(of: "_", with: " "))"
        }
        return ""
    }
}


extension Date {
    func convertToTimeZone(timeZone: TimeZone) -> Date {
         let delta = TimeInterval(timeZone.secondsFromGMT(for: self) - TimeZone.current.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
