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
        case AppConstants.httpPostMethod:
            break
        case AppConstants.httpGetMethod:
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


