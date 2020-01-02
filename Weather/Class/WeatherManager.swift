//
//  WeatherManager.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/18.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import Foundation

class WeatherManager {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let key = getWeatherAPIString()
    
//    func getWeather(where city: String) {
//        let session = URLSession.shared
//        let weatherRequestURL = URL(string: String(format: "%@?APPID=%@&q=%@", baseURL, key, city))!
//
//        let dataTask = session.dataTask(with: weatherRequestURL) { (data: Data?, response: URLResponse?, error: Error?) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Raw data: \(String(describing: data))")
//                if let data = data {
//                    let dataString = String(bytes: data, encoding: .utf8)
//                    print("\(String(describing: dataString))")
//                }
//            }
//        }
//        dataTask.resume()
//    }
    
    func getCurrentWeatherData(latitude: Double, longitude: Double, completion: @escaping (([String: Any]) -> Void)) {
        let session = URLSession.shared
        guard let url = URL(string: String(format: "%@?APPID=%@&lat=%f&lon=%f", baseURL, key, latitude, longitude)) else {
            print("URL is nill")
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error  in
            guard error == nil else {
                print("통신에러")
                print(error?.localizedDescription as Any)
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
}
