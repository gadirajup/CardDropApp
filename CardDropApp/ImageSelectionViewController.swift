//
//  ImageSelectionViewController.swift
//  CardDropApp
//
//  Created by Prudhvi Gadiraju on 4/11/19.
//  Copyright © 2019 Brian Advent. All rights reserved.
//

import UIKit

class ImageSelectionViewController: UIViewController {

    var image: UIImage?
    var category: Category?
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = image, let availableCategory = category {
            initialImageView.image = availableImage
            categoryName.text = availableCategory.categoryName
        }
    }
}
