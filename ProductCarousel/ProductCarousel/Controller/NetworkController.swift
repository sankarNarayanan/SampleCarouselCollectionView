//
//  NetworkController.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 11/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import Foundation

class NetworkController {
    
    func makeWebServiceCall(toUrl: String, method: String, callback : (response: NSData?, error: NSError?) -> Void){
        var request : NSURLRequest?
        switch method {
        case "POST":
            break
        case "GET":
            request = NSURLRequest(URL: NSURL(string: toUrl)!)
            break
        default:
            break
        }
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request!, completionHandler: { data, response, error in
            callback(response: data, error: error)
        })
        task.resume()
    }
}

import Foundation

extension String {
    func sliceFrom(start: String, to: String) -> String? {
        return (rangeOfString(start)?.endIndex).flatMap { sInd in
            (rangeOfString(to, range: sInd..<endIndex)?.startIndex).map { eInd in
                substringWithRange(sInd..<eInd)
            }
        }
    }
}
