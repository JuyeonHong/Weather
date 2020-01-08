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
    
    var forecast: Forecast? {
        didSet {
            if let data = forecast {
                let date = data.date
                let iconId = data.weatherIconId
                tempLabel.text = WeatherManager.convertTemp(temp: data.temp, from: .kelvin, to: .celsius)
            }
        }
    }
}
