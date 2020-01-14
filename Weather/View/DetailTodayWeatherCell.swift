//
//  DetailTodayWeatherCell.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/11.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class DetailTodayWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var feelslikeLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    var weather: Weather? {
        didSet {
            if let data = weather {
                sunriseLabel.text = WeatherManager.convertUnixTime(time: data.sunrise, timeZone: data.timezone)
                
                sunsetLabel.text = WeatherManager.convertUnixTime(time: data.sunset, timeZone: data.timezone)
                
                cloudsLabel.text = String(format: "%d %@", data.clouds, "%")
                
                humidityLabel.text = String(format: "%d %@", data.humidity, "%")
                
                let spd = data.wind.value(forKey: "speed") as? Double ?? 0
                let speed = Measurement(value: spd, unit: UnitSpeed.metersPerSecond).description
                let deg = data.wind.value(forKey: "deg") as? Double ?? 0
                let direction = deg.direction.description
                windLabel.text = String(format: "%@ %@", direction, speed)
                
                feelslikeLabel.text = WeatherManager.convertTemp(temp: data.feels_like, from: .kelvin, to: .celsius, tempStringUnit: .withDegree)
                
                let visibility = data.visibility
                let intVal = Measurement(value: Double(data.visibility), unit: UnitLength.meters)
                if visibility < 1000 {
                    visibilityLabel.text = intVal.description
                } else {
                    let doubleVal = intVal.converted(to: .kilometers)
                    visibilityLabel.text = doubleVal.description
                }
                
                let pressure = Measurement(value: Double(data.pressure), unit: UnitPressure.hectopascals)
                pressureLabel.text = pressure.description
            }
        }
    }
}
