//
//  HtmlParser.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 13/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import Foundation

class HtmlParser: NSObject {
    
    func parseHtmlData(htmlData : NSData) -> [CategoryModel]{
        
        //Model to be returned
        
        var categoryModels : [CategoryModel] = [CategoryModel]()
        
        //Initialize HTML data
        
        let data = NSData(data: htmlData)
        let doc = TFHpple(HTMLData: data)
        
        
        //To get the category names
        var categoryNamesArray : [String] = [String]()
        if let categoryNamesList = doc.searchWithXPathQuery("//div[@class = 'col-sm-9']") as? [TFHppleElement]{
            for categoryName in categoryNamesList{
                if let categoryFirstChild = categoryName.firstChildWithTagName("h2"){
                    categoryNamesArray.append(categoryFirstChild.content)
                }
            }
        }
        
        //To get product models in category
        if let baseElements = doc.searchWithXPathQuery("//div[@class = 'mask']") as? [TFHppleElement]{
            var counter = 0
            for rootElement in baseElements {
                let listParent = rootElement.firstChildWithTagName("ul")
                let listChildren = listParent.childrenWithTagName("li")
                var productArray:[ProductModel] = [ProductModel]()
                for listElement in listChildren{
                    let listAnchors = listElement.childrenWithTagName("a")
                    //Variables to be initialized
                    var imageLink = ""
                    var productName = ""
                    var storeTitle = ""
                    var discountedPrice = ""
                    for anchorChild in listAnchors{
                        //To get image link
                        if let immediateImageHolder = anchorChild.firstChildWithClassName("img-holder"){
                            if let actualImageTag = immediateImageHolder.firstChildWithTagName("img"){
                                imageLink = actualImageTag.objectForKey("src")
                            }
                        }
                        //To get product Description
                        if let productNameSpanHolder = anchorChild.firstChildWithTagName("span"){
                            productName = productNameSpanHolder.content
                        }
                        
                        
                    }
                    //To get store details
                    if let storeTitleTag = listElement.firstChildWithClassName("title text-uppercase"){
                        storeTitle = storeTitleTag.content
                    }
                    //To get price
                    if let basePriceTag = listElement.firstChildWithTagName("strong"){
                        if let discountedPriceSpanTag = basePriceTag.firstChildWithTagName("span"){
                            discountedPrice = discountedPriceSpanTag.content
                        }
                    }
                    
                    let productModel = ProductModel(withImageLink: imageLink, productName: productName, storeName: storeTitle, discountedTitle: discountedPrice)
                    productArray.append(productModel)
                }
                
                //Create Category Model
                if (categoryNamesArray.count == baseElements.count){
                    let categoryModel = CategoryModel(withCategoryName: categoryNamesArray[counter], productModels: productArray)
                    categoryModels.append(categoryModel)
                    
                }
                counter += 1
            }
        }
        return categoryModels
    }
    
    
    
    
    
}
