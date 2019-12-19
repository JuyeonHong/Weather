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
    
    func getWeather(where city: String) {
        let session = URLSession.shared
        let weatherRequestURL = URL(string: String(format: "%@?APPID=%@&q=%@", baseURL, key, city))!
        
        let dataTask = session.dataTask(with: weatherRequestURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Raw data: \(String(describing: data))")
                if let data = data {
                    let dataString = String(bytes: data, encoding: .utf8)
                    print("\(String(describing: dataString))")
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
