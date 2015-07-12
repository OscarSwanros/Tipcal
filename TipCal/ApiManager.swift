//
//  ApiManager.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/12/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import Foundation

let api_base = "https://currency-exchange.p.mashape.com"
let api_key  = "8PVaHmcUtSmshRIjf7PRhBqctb7sp1rp65XjsnbHalE5NLfZhA"
let kCurrencyExchangeUpdatedNotificationName = "kCurrencyExchangeUpdatedNotification"

let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())

enum Endpoint: String {
    case Exchange = "/exchange"
    
    func toURL() -> NSURL {
        return NSURL(string: "\(api_base)\(self.rawValue)")!
    }
}


func updateCurrencyExchangeRate() {
    PTNetworkActivityIndicator.showNetworkActivityIndicator()
    let request = NSMutableURLRequest(URL: Endpoint.Exchange.toURL().pt_URLWithParams(["from":"USD", "to":"MXN"])!)
    request.setValue(api_key, forHTTPHeaderField: "X-Mashape-Key")
    request.setValue("text/plain", forHTTPHeaderField: "Accept")
    
    let task = defaultSession.dataTaskWithRequest(request, completionHandler: {data, response, error in
        PTNetworkActivityIndicator.hideNetworkActivityIndicator()
        let info = NSString(data: data, encoding: NSUTF8StringEncoding)?.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        if let ce = info,
           let value = stringToNumber(ce) {
            setCurrentExchangeRate(value.floatValue)
            
            executeOnMainThread({
                NSNotificationCenter.defaultCenter().postNotificationName(kCurrencyExchangeUpdatedNotificationName, object: nil)
            })
        }
    })
    
    task.resume()
}