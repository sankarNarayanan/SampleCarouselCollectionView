//
//  CategoryModel.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 14/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import Foundation

struct CategoryModel {
    var categoryName : String?
    var associatedProducts : [ProductModel]?
    
    init(withCategoryName : String, productModels : [ProductModel]){
        self.categoryName = withCategoryName
        self.associatedProducts = productModels
    }
    
}
