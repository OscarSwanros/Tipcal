//
//  Utils.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/11/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import Foundation

let userDefaults = NSUserDefaults.standardUserDefaults()

func stringToNumber(s: String) -> NSNumber? {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = .DecimalStyle
    
    return numberFormatter.numberFromString(s)
}

func user_defaults_set_float(value: Float, key: String) {
    userDefaults.setFloat(value, forKey: key)
    userDefaults.synchronize()
}

func user_defaults_get_float(key: String) -> Float {
    return userDefaults.floatForKey(key)
}

func user_defaults_set_bool(value: Bool, key: String) {
    userDefaults.setBool(value, forKey: key)
    userDefaults.synchronize()
}

func user_defaults_get_bool(key: String) -> Bool {
    return userDefaults.boolForKey(key)
}

func user_defaults_set_string(value: String, key: String) {
    userDefaults.setValue(value, forKey: key)
    userDefaults.synchronize()
}

func user_defaults_get_string(key: String) -> String {
    if let s = userDefaults.valueForKey(key) as? String {
        return s
    }
    
    return ""
}