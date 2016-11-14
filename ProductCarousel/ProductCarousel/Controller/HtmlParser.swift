//
//  HtmlParser.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 13/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import Foundation

struct HtmlParserConstants {
    static let categoryNameSearchKey = "//div[@class = 'col-sm-9']"
    static let productBaseSearchKey = "//div[@class = 'mask']"
    static let ulKey = "ul"
    static let liKey = "li"
    static let headingKey = "h2"
    static let anchorKey = "a"
    static let imgHolderClassKey = "img-holder"
    static let imgKey = "img"
    static let imgSrcKey = "src"
    static let spanKey = "span"
    static let classSearchSpec = "title text-uppercase"
    static let strongKey = "strong"
}

class HtmlParser: NSObject {
    
    func parseHtmlData(htmlData : NSData) -> [CategoryModel]{
        
        //Model to be returned
        
        var categoryModels : [CategoryModel] = [CategoryModel]()
        
        //Initialize HTML data
        
        let data = NSData(data: htmlData)
        let doc = TFHpple(HTMLData: data)
        
        
        //To get the category names
        var categoryNamesArray : [String] = [String]()
        if let categoryNamesList = doc.searchWithXPathQuery(HtmlParserConstants.categoryNameSearchKey) as? [TFHppleElement]{
            for categoryName in categoryNamesList{
                if let categoryFirstChild = categoryName.firstChildWithTagName(HtmlParserConstants.headingKey){
                    categoryNamesArray.append(categoryFirstChild.content)
                }
            }
        }
        
        //To get product models in category
        if let baseElements = doc.searchWithXPathQuery(HtmlParserConstants.productBaseSearchKey) as? [TFHppleElement]{
            var counter = 0
            for rootElement in baseElements {
                let listParent = rootElement.firstChildWithTagName(HtmlParserConstants.ulKey)
                let listChildren = listParent.childrenWithTagName(HtmlParserConstants.liKey)
                var productArray:[ProductModel] = [ProductModel]()
                for listElement in listChildren{
                    let listAnchors = listElement.childrenWithTagName(HtmlParserConstants.anchorKey)
                    //Variables to be initialized
                    var imageLink = ""
                    var productName = ""
                    var storeTitle = ""
                    var discountedPrice = ""
                    for anchorChild in listAnchors{
                        //To get image link
                        if let immediateImageHolder = anchorChild.firstChildWithClassName(HtmlParserConstants.imgHolderClassKey){
                            if let actualImageTag = immediateImageHolder.firstChildWithTagName(HtmlParserConstants.imgKey){
                                imageLink = actualImageTag.objectForKey(HtmlParserConstants.imgSrcKey)
                            }
                        }
                        //To get product Description
                        if let productNameSpanHolder = anchorChild.firstChildWithTagName(HtmlParserConstants.spanKey){
                            productName = productNameSpanHolder.content
                        }
                        
                        
                    }
                    //To get store details
                    if let storeTitleTag = listElement.firstChildWithClassName(HtmlParserConstants.classSearchSpec){
                        storeTitle = storeTitleTag.content
                    }
                    //To get price
                    if let basePriceTag = listElement.firstChildWithTagName(HtmlParserConstants.strongKey){
                        if let discountedPriceSpanTag = basePriceTag.firstChildWithTagName(HtmlParserConstants.spanKey){
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
