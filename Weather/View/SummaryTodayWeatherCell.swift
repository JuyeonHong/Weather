//
//  SummaryTodayWeatherCell.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/11.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class SummaryTodayWeatherCell: UICollectionViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    var weather: Weather? {
        didSet {
            if let data = weather {
                let temp = WeatherManager.convertTemp(temp: data.temp, from: .kelvin, to: .celsius)
                let temp_max = WeatherManager.convertTemp(temp: data.temp_max, from: .kelvin, to: .celsius)
                let str = String(format: "Today: %@ currently. It's %@; the high today was forecast as %@",data.description, temp, temp_max)
                descriptionLabel.text = str
            }
        }
    }
}
