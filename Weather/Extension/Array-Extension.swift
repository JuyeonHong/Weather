//
//  Array-Extension.swift
//  Weather
//
//  Created by hongjuyeon_dev on 2020/01/09.
//  Copyright © 2020 hongjuyeon_dev. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    // array 중복제거
    func removeDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter { addedDict.updateValue(true, forKey: $0) == nil }
    }
}
