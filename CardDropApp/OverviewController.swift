//
//  OverviewController.swift
//  CardDropApp
//
//  Created by Prudhvi Gadiraju on 4/11/19.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import UIKit

class OverviewController: UICollectionViewController {
    
    let categoryDataRequest = DataRequest<Category>(dataSource: "Categories")
    var categoryData = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData() {
        categoryDataRequest.getData { [weak self] (dataResult) in
            switch dataResult {
            case .failure:
                print("Couldn't Load Categories")
            case .success(let categories):
                self?.categoryData = categories
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let category = sender as! Category
            guard let image = UIImage(named: category.categoryImageName) else {return}
            let imageSelectionVC = segue.destination as! ImageSelectionViewController
            imageSelectionVC.image = image
            imageSelectionVC.category = category
        }
    }
}

// CollectionView DataSource
extension OverviewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        
        let category = categoryData[indexPath.row]
        let image = category.categoryImageName
        
        cell.image.image = UIImage(named: image)
        cell.label.text = category.categoryName
        
        return cell
    }
    
}

// CollectionView Delegate
extension OverviewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.cornerRadius = 14
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoryData[indexPath.item]
        self.performSegue(withIdentifier: "showDetail", sender: category)
    }
}

// CollectionView Flow layout
extension OverviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60) / 2
        return .init(width: width, height: width*1.5)
    }
}
