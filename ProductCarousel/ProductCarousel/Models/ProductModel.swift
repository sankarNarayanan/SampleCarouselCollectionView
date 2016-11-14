//
//  ProductModel.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 14/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import Foundation

struct ProductModel {
    //Model variables
    var imageLink : String?
    var productName: String?
    var storeName:String?
    var discountedTitle : String?
    
    //Model Constructor
    init(withImageLink : String, productName: String, storeName: String, discountedTitle : String){
        self.imageLink = withImageLink
        self.productName = productName
        self.storeName = storeName
        self.discountedTitle = discountedTitle
    }
}
