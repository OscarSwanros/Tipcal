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

class Result: NSObject, NSCoding {
    var amount: Float?
    var currency: Currency?
    var date: NSDate?
    
    init(amout: Float, currency: Currency, date: NSDate) {
        self.amount = amout
        self.currency = currency
        self.date = date
    }
    
    required init(coder aDecoder: NSCoder) {
        self.amount = aDecoder.decodeFloatForKey("amount")
        self.currency = Currency(rawValue: aDecoder.decodeObjectForKey("currency") as! String)
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(self.amount!, forKey: "amount")
        aCoder.encodeObject(self.currency?.rawValue, forKey: "currency")
        aCoder.encodeObject(self.date!, forKey: "date")
    }
}

let currency_key = "Currency"
let current_rate_key = "CurrentRate"
let last_result_key = "LastResult"

var lastResult: Result? {
    let data = user_defaults_get_object(last_result_key) as? NSData
    if let data = data {
        let r = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Result
        if let r = r {
            let seconds = -Int(r.date!.timeIntervalSinceNow)
            let hours = seconds/3600
            
            if hours > 1 {
                return nil
            }
            
            return r
        }
    }
    
    return nil
}

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

func saveResult(r: Result) {
    let data = NSKeyedArchiver.archivedDataWithRootObject(r)
    user_defaults_set_object(data, last_result_key)
}
