//
//  Foundation.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/12/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import Foundation

func pt_URLEncode(o: AnyObject) -> String {
    let string = o as? String
    if let s = string {
        return s.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
    }
    
    return ""
}

extension Dictionary {
    func pt_URLEncodedString() -> String {
        var pairs = Array<String>()
        
        for element in self {
            let queryPair = "\(pt_URLEncode((element.0 as? String)!))=\(pt_URLEncode((element.1 as? String)!))"
            
            pairs.append(queryPair)
        }
        
        return join("&", pairs)
    }
}

extension NSURL {
    func pt_URLWithParams(params: [String:String])-> NSURL? {
        return NSURL(string: "\(self)?\(params.pt_URLEncodedString())")
    }
}