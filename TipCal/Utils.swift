//
//  Utils.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/11/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import Foundation

func stringToNumber(s: String) -> NSNumber? {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = .DecimalStyle
    
    return numberFormatter.numberFromString(s)
}