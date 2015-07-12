//
//  CurrencyManager.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/12/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import Foundation

enum Currency: String {
    case USD = "USD"
    case MXN = "MXN"
    
    func titleString() -> String {
        return "To \(self.rawValue)"
    }
}

let currency_key = "Currency"
let current_rate_key = "CurrentRate"

func setCurrentExchangeRate(f: Float) {
    user_defaults_set_float(f, current_rate_key)
}

func setCurrentCurrency(c: Currency) {
    user_defaults_set_string(c.rawValue, currency_key)
}

var currentCurrency: Currency? {
    return Currency(rawValue: user_defaults_get_string(currency_key))
}

func currentExchangeRate() -> Float {
    return user_defaults_get_float(current_rate_key)
}

func fromUSDToMXN(x: Float) -> Float {
    return x * currentExchangeRate()
}

func fromMXNToUSD(x: Float) -> Float {
    return x / currentExchangeRate()
}