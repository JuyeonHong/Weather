//
//  WeatherManager.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/18.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import Foundation

enum UnitTemperatureType: String {
    case withDegree // ex. 4°
    case nonDegree // ex. 4
}

class WeatherManager {
    static func convertUnixTime(time: Int64?, timeZone: Int64) -> String {
        var convertedDate = ""
        
        if let unixTime = time {
            let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
            let dateFormatter = DateFormatter()
            let timezone = TimeZone(secondsFromGMT: Int(timeZone))
            dateFormatter.timeZone = timezone
            dateFormatter.locale = NSLocale.current
            dateFormatter.timeStyle = .short // ex. 07.43 AM
            convertedDate = dateFormatter.string(from: date)
        }
        
        return convertedDate
    }
    
    static func convertUnixDate(date: Int?, timeZone: Int64) -> String {
        var convertedDate = ""
        
        if let unixDate = date {
            let date = Date(timeIntervalSince1970: TimeInterval(unixDate))
            let dateFormatter = DateFormatter()
            let timezone = TimeZone(secondsFromGMT: Int(timeZone))
            dateFormatter.timeZone = timezone
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy.MM.dd"
            convertedDate = dateFormatter.string(from: date)
        }
        
        return convertedDate
    }
    
    static func getDayOfWeek(date: Date) -> String {
        var dow = ""
        
        let calender = Calendar(identifier: .gregorian)
        let comps = calender.dateComponents([.weekday], from: date)
        let today = comps.weekday!
        
        switch today {
        case 1: dow = "Sunday"
        case 2: dow = "Monday"
        case 3: dow = "Tuesday"
        case 4: dow = "Wednesday"
        case 5: dow = "Thursday"
        case 6: dow = "Friday"
        case 7: dow = "Saturday"
        default: dow = ""
        }
        
        return dow
    }
    
    static func getTodayDate(dateFormat: String) -> String {
        let df = DateFormatter()
        df.dateFormat = dateFormat
        let currentDate = df.string(from: Date())
        return currentDate
    }
    
    static func getCurrentTime() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return df.string(from: Date())
    }
    
    static func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature, tempStringUnit: UnitTemperatureType) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        
        if outputTempType == UnitTemperature.celsius {
            if tempStringUnit == .withDegree {
                return mf.string(from: output).replacingOccurrences(of: "C", with: "")
            } else if tempStringUnit == .nonDegree {
                return mf.string(from: output).replacingOccurrences(of: "°C", with: "")
            }
        }
        return mf.string(from: output)
    }
    
//// https://openweathermap.org/weather-conditions
    static func getWeatherSysImgName(weather id: Int, isNight: Bool = false) -> String {
        var imgString = ""
        let index = (id.description.first)
        
        if index == "2" {
            imgString = "cloud.bolt.rain.fill"
        }
        else if index == "3" {
            imgString = "cloud.drizzle.fill"
        }
        else if index == "5" {
            if id < 502 {
                imgString = "cloud.rain.fill"
            } else if id < 511 {
                imgString = "cloud.heavyrain.fill"
            } else if id == 511 {
                imgString = "snow"
            } else  if id > 519 && id < 540 {
                imgString = "cloud.hail.fill"
            }
        }
        else if index == "6" {
            if id >= 600 && id < 603 {
                imgString = "snow"
            } else if id > 603 && id < 625 {
                imgString = "cloud.snow.fill"
            }
        }
        else if index == "7" {
            if id == 701 || ( id > 720 && id < 750 ){
               imgString = "cloud.fog.fill"
            } else if id == 711 {
                imgString = "smoke.fill"
            } else if id > 750 && id < 770 {
                imgString = "sun.dust.fill"
            } else if id > 770 && id < 790 {
                imgString = "tornado"
            }
        } else if index == "8" {
            if id == 800 {
                imgString = "sun.max.fill"
                if isNight {
                    imgString = "moon.stars.fill"
                }
            } else if id == 801 {
                imgString = "cloud.sun.fill"
                if isNight {
                    imgString = "cloud.moon.fill"
                }
            } else if id == 802 || id == 803 || id == 804 {
                imgString = "cloud.fill"
            }
        }

        return imgString
    }
}
