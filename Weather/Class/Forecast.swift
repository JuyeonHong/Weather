//
//  Forecast.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2020/01/07.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import Foundation

struct Forecast {
    let date: String // 날짜
    let time: String // 시간
    let main: String // 날씨
    let weatherId: Int // 날씨 상태 아이디
    let temp: Double // 현재 온도
    let temp_max: Double // 최고온도
    let temp_min: Double // 최저온도
    
    init(date: String, time: String, main: String, weatherId: Int, temp: Double, temp_max: Double, temp_min: Double) {
        self.date = date
        self.time = time
        self.main = main
        self.weatherId = weatherId
        self.temp = temp
        self.temp_max = temp_max
        self.temp_min = temp_min
    }
    
    init?(dict: [String: Any]) {
        let date = dict["dt_txt"] as? String ?? ""
        let dateComp = date.components(separatedBy: " ")
        self.date = dateComp.first ?? ""
        self.time = dateComp.last ?? ""
        let main = dict["main"] as? NSDictionary
        self.temp = main?["temp"] as? Double ?? 0
        self.temp_max = main?["temp_max"] as? Double ?? 0
        self.temp_min = main?["temp_min"] as? Double ?? 0
        let weather = (dict["weather"] as? NSArray)?.firstObject as? NSDictionary
        self.main = weather?["main"] as? String ?? ""
        self.weatherId = weather?["id"] as? Int ?? 0
    }
}

class ForecastManager {
    static func loadForecastArray(dict: [String: Any]) -> [Forecast] {
        var forecastArray: [Forecast] = []
        if let arr = dict["list"] as? NSArray {
            for item in arr {
                if let data = item as? [String: Any],
                    let forecast = Forecast(dict: data) {
                        forecastArray.append(forecast)
                }
            }
        }
        return forecastArray
    }
}
