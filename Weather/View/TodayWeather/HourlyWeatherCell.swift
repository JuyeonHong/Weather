//
//  HourlyWeatherCell.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2020/01/08.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherImgView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    var isNight = false
    
    var forecast: Forecast? {
        didSet {
            if let data = forecast {
                let timeData = data.time
                
                let df = DateFormatter()
                df.dateFormat = "HH:mm:ss"
                df.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                let date = df.date(from: timeData)
                
                df.dateFormat = "Ha"
                if let dt = date {
                   let convertedDate = df.string(from: dt)
                    timeLabel.text = convertedDate
                    if convertedDate.contains("PM") {
                        isNight = true
                    } else {
                        isNight = false
                    }
                }
                
                let imgString = WeatherManager.getWeatherSysImgName(weather: data.weatherId, isNight: isNight)
                weatherImgView.image = UIImage(systemName: imgString)
                
                tempLabel.text = WeatherManager.convertTemp(temp: data.temp, from: .kelvin, to: .celsius)
            }
        }
    }
}
