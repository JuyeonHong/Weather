//
//  WeatherHeaderView.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/11.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class WeatherHeaderView: UICollectionReusableView {
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
}
