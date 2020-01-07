//
//  Forecast.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2020/01/07.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import Foundation

struct Forecast {
    let date: Int // 날짜
    let main: String // 날씨
    let weatherIconId: String // 날씨 아이콘 아이디
    let temp: Double // 현재 온도
    let temp_max: Double // 최고온도
    let temp_min: Double // 최저온도
    
    init(date: Int, main: String, weatherIconId: String, temp: Double, temp_max: Double, temp_min: Double) {
        self.date = date
        self.main = main
        self.weatherIconId = weatherIconId
        self.temp = temp
        self.temp_max = temp_max
        self.temp_min = temp_min
    }
    
    init?(dict: [String: Any]) {
        self.date = dict["dt"] as? Int ?? 0
        let main = dict["main"] as? NSDictionary
        self.temp = main?["temp"] as? Double ?? 0
        self.temp_max = main?["temp_max"] as? Double ?? 0
        self.temp_min = main?["temp_min"] as? Double ?? 0
        let weather = (dict["weather"] as? NSArray)?.firstObject as? NSDictionary
        self.main = weather?["main"] as? String ?? ""
        self.weatherIconId = weather?["icon"] as? String ?? ""
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
