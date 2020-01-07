//
//  Weather.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2020/01/02.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import Foundation

struct Weather {
    let name: String // 지역명
    let main: String // 날씨 설명
    let description: String // 날씨 부가설명
    let temp: Double // 현재 온도
    let temp_max: Double // 최고온도
    let temp_min: Double // 최저온도
    
    let sunrise: Int64 // 일출
    let sunset: Int64 // 일몰
    let clouds: Int64
    let humidity: Int64 // 습도
    let wind: NSDictionary // 바람
    let feels_like: Double // 체감
    let pressure: Int64 // 기압
    let visibility: Int64 // 가시거리
    
    let timezone: Int64
    
    init(name: String, main: String, description: String, temp: Double, temp_max: Double, temp_min: Double,
         sunrise: Int64, sunset: Int64, clouds: Int64, humidity: Int64, wind: NSDictionary, feels_like: Double,
         pressure: Int64, visibility: Int64, timezone: Int64) {
        self.name = name
        self.main = main
        self.description = description
        self.temp = temp
        self.temp_max = temp_max
        self.temp_min = temp_min
        
        self.sunrise = sunrise
        self.sunset = sunset
        self.clouds = clouds
        self.humidity = humidity
        self.wind = wind
        self.feels_like = feels_like
        self.pressure = pressure
        self.visibility = visibility
        
        self.timezone = timezone
    }
    
    init?(dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.visibility = dict["visibility"] as? Int64 ?? 0
        self.timezone = dict["timezone"] as? Int64 ?? 0
        
        let main = dict["main"] as? NSDictionary
        self.temp = main?.value(forKey: "temp") as? Double ?? 0
        self.temp_max = main?.value(forKey: "temp_max") as? Double ?? 0
        self.temp_min = main?.value(forKey: "temp_min") as? Double ?? 0
        self.feels_like = main?.value(forKey: "feels_like") as? Double ?? 0
        self.humidity = main?.value(forKey: "humidity") as? Int64 ?? 0
        self.pressure = main?.value(forKey: "pressure") as? Int64 ?? 0
        
        let weather = (dict["weather"] as? NSArray)?.firstObject as? NSDictionary
        self.main = weather?["main"] as? String ?? ""
        self.description = weather?["description"] as? String ?? ""
        
        let sys = dict["sys"] as? NSDictionary ?? [:]
        self.sunrise = sys.value(forKey: "sunrise") as? Int64 ?? 0
        self.sunset = sys.value(forKey: "sunset") as? Int64 ?? 0
        
        let clouds = dict["clouds"] as? NSDictionary
        self.clouds = clouds?.value(forKey: "all") as? Int64 ?? 0
        
        self.wind = dict["wind"] as? NSDictionary ?? [:]
    }
}
