//
//  WeeklyForecast.swift
//  Weather
//
//  Created by 홍주연 on 10/01/2020.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import Foundation

struct WeeklyForecast {
    let date: String // 날짜
    let weatherId: Int // 날씨 상태 아이디
    let temp_max: Double // 최고온도
    let temp_min: Double // 최저온도
    
    init(date: String, weatherId: Int, temp_max: Double, temp_min: Double) {
        self.date = date
        self.weatherId = weatherId
        self.temp_max = temp_max
        self.temp_min = temp_min
    }
    
    init?(dict: [String: Any]) {
        let date = dict["dt_txt"] as? String ?? ""
        let dateComp = date.components(separatedBy: " ")
        self.date = dateComp.first ?? ""
        let main = dict["main"] as? NSDictionary
        self.temp_max = main?["temp_max"] as? Double ?? 0
        self.temp_min = main?["temp_min"] as? Double ?? 0
        let weather = (dict["weather"] as? NSArray)?.firstObject as? NSDictionary
        self.weatherId = weather?["id"] as? Int ?? 0
    }
}

class WeeklyForecastManager {
    static func loadWeelyForecastArray(dict: [String: Any]) -> [WeeklyForecast] {
        var weeklyArray: [WeeklyForecast] = []
        if let arr = dict["list"] as? NSArray {
            for item in arr {
                if let data = item as? [String: Any],
                    let forecast = WeeklyForecast(dict: data) {
                        weeklyArray.append(forecast)
                }
            }
        }
        return weeklyArray
    }
}
