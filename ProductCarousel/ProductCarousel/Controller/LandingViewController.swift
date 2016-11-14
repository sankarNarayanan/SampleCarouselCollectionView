//
//  LandingViewController.swift
//  ProductCarousel
//
//  Created by Sankar Narayanan on 08/11/16.
//  Copyright © 2016 Sankar Narayanan. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var pickerTextField: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var categoryModels : [CategoryModel]? = nil
    var productModels : [ProductModel]? = nil
    var pickerView : UIPickerView?
    let nController = NetworkController()
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        super.viewDidLoad()
        self.nController.makeWebServiceCall(AppConstants.baseUrl, method: AppConstants.httpGetMethod, callback: {(response: NSData?, error: NSError?) -> Void in
            if (response != nil){
                dispatch_async(dispatch_get_main_queue()) {
                    self.setUpCarousel(response!)
                }
            }
        })
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //PRAGMA MARK: Collection view deleagtes
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productModels?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AppConstants.containerCell, forIndexPath: indexPath) as! ProductCollectionCell
        let currentProduct = self.productModels![indexPath.row]
        self.nController.makeWebServiceCall(currentProduct.imageLink!, method: AppConstants.httpGetMethod , callback: {(response: NSData?, error: NSError?) -> Void in
            if ((response) != nil) {
                dispatch_async(dispatch_get_main_queue()) {
                    cell.productImage.image = UIImage(data: response!)
                }
            }
        })
        cell.productCost.text = currentProduct.discountedTitle ?? ""
        let trimmedString = self.condenseWhitespace(currentProduct.storeName ?? "")
        cell.storeName.text = trimmedString
        cell.productName.text = currentProduct.productName ?? ""
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (self.collectionView.frame.width - 10), height: (self.collectionView.frame.height - 10))
    }
    
    
    
    //PRAGMA MARK: Picker view delegates
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return self.categoryModels?.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categoryModel = self.categoryModels![row]
        return categoryModel.categoryName ?? ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let categoryModel = self.categoryModels![row]
        pickerTextField.text = categoryModel.categoryName ?? ""
        self.productModels = categoryModel.associatedProducts
    }
    
    //PRAGMA MARK: Picker view actions
    
    func displayproductForCategory(){
        self.collectionView.reloadData()
        self.pickerTextField.resignFirstResponder()
    }
    
    func cancelAction(){
        self.pickerTextField.resignFirstResponder()
    }
    
    //PRAGMA MARK: Utilities
    
    func setUpCarousel(response : NSData?){
        let parser = HtmlParser()
        let models = parser.parseHtmlData(response!)
        self.categoryModels = models
        self.pickerView = UIPickerView()
        self.pickerView!.delegate = self
        self.pickerView!.dataSource = self
        self.pickerTextField.inputView = self.pickerView!
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: AppConstants.doneBtnTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LandingViewController.displayproductForCategory))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: AppConstants.cancelBtnTitle, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(LandingViewController.cancelAction))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        self.pickerTextField.inputAccessoryView = toolBar
        self.collectionView.pagingEnabled = true
        let categoryModel = self.categoryModels![0]
        pickerTextField.text = categoryModel.categoryName ?? ""
        self.productModels = categoryModel.associatedProducts
        self.collectionView.reloadData()
        self.pickerTextField.tintColor = UIColor.clearColor()
        self.collectionView.showsHorizontalScrollIndicator = false
        self.pageControl.numberOfPages = self.productModels?.count ?? 0
    }
    
    func condenseWhitespace(string: String) -> String {
            let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let filtered = components.filter({!$0.isEmpty})
            let response = filtered.joinWithSeparator(" ")
            let test = String(response.characters.filter { !AppConstants.escapeCharacters.characters.contains($0) })
            return test
    }
    
}



extension LandingViewController : UIScrollViewDelegate{
    
    //To set page control page
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = CGRectGetWidth(scrollView.frame)
        self.pageControl.currentPage = Int(collectionView.contentOffset.x / pageWidth)
    }
    
    
}

