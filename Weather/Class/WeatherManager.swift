//
//  WeatherManager.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/18.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import Foundation

enum DataType: String {
    case weather
    case forecast
}

class WeatherManager {
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let key = getWeatherAPIString()
    
    func getWeatherData(data type: DataType, latitude: Double, longitude: Double, completion: @escaping (([String: Any]) -> Void)) {
        let session = URLSession.shared
        guard let url = URL(string: String(format: "%@%@?APPID=%@&lat=%f&lon=%f", baseURL, type.rawValue, key, latitude, longitude)) else {
            print("URL is nill")
            return
        }
        print(url)
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 180
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error  in
            guard error == nil else {
                print("####통신에러####")
                if let errorCode = error as NSError?, errorCode.code == NSURLErrorTimedOut {
                    print("####TIME OUT####")
                } else {
                    print(error?.localizedDescription as Any)
                }
                return
            }
            // 데이터가 있는 경우
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                //euc-kr 로 디코딩
                var tempString = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422)))
                //nil 이면 utf8로 디코딩
                if(tempString == nil){
                    tempString =  String(decoding: data, as: UTF8.self)
                }
                //리턴과뉴라인 삭제
                let dataString = tempString?.filter { !"\r\n".contains($0) }
                if let data = dataString?.data(using: .utf8) {
                    guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        print("json to array error")
                        completion(error as! [String : Any])
                        return
                    }
                    print(jsonToArray)
                    completion(jsonToArray as! [String: Any])
                }
            }
        }
        dataTask.resume()
    }
    
    static func getWeatherAPIString() -> String {
        var keyString = ""
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let valueDict = NSDictionary(contentsOfFile: path) {
            keyString = valueDict["OPEN_WEATHER_API_KEY"] as? String ?? ""
        }
        return keyString
    }
}

extension WeatherManager {
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
    
    static func getTodayDayOfWeek() -> String {
        var dow = ""
        
        let calender = Calendar(identifier: .gregorian)
        let now = Date()
        let comps = calender.dateComponents([.weekday], from: now)
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
    
    static func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
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
