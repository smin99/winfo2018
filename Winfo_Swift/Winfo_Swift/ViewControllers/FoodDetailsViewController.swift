//
//  FoodDetailsViewController.swift
//  Winfo_Swift
//
//  Created by HwangSeungmin on 1/12/19.
//  Copyright © 2019 Min. All rights reserved.
//

import UIKit

class FoodDetailsViewController: UIViewController {
    
    var mapButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapButton = UIBarButtonItem(image: UIImage(named: "MapIcon"), style: .plain, target: self, action: #selector(mapSelected))
        self.navigationItem.rightBarButtonItem = mapButton
    }

    @objc func mapSelected(_ sender: Any) {
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "FoodMapViewController") as! FoodMapViewController
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }

}
