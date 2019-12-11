//
//  WeatherLayoutAttributes.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2019/12/11.
//  Copyright © 2019 hongjuyeon_dev. All rights reserved.
//

import UIKit

class WeatherLayoutAttributes: UICollectionViewLayoutAttributes {
    var initialOrigin: CGPoint = .zero
    
    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copiedAttributes = super.copy(with: zone) as? WeatherLayoutAttributes else {
            return super.copy(with: zone)
        }
        copiedAttributes.initialOrigin = initialOrigin
        return copiedAttributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherAttributes = object as? WeatherLayoutAttributes else {
            return false
        }
        if otherAttributes.initialOrigin != initialOrigin {
            return false
        }
        return super.isEqual(object)
    }
}
