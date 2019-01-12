//
//  ViewController.swift
//  Winfo_Swift
//
//  Created by HwangSeungmin on 1/12/19.
//  Copyright © 2019 Min. All rights reserved.
//

import UIKit
import SideMenu
import SwiftMessages
import SkyFloatingLabelTextField

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SideMenu Initialization
        SideMenuManager.default.menuPushStyle = .defaultBehavior
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = view.frame.width * 0.8
//        if let sideMenu = storyboard?.instantiateViewController(withIdentifier: "leftSideMenu") {
//            SideMenuManager.default.menuLeftNavigationController = sideMenu as? UISideMenuNavigationController
//
//            SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
//            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
//        }
        
//        searchButton = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .plain, target: self, action: #selector(searchSelected))
//        cameraButton = UIBarButtonItem(image: UIImage(named: "CameraIcon"), style: .plain, target: self, action: #selector(cameraSelected))
//        self.navigationItem.rightBarButtonItem = searchButton
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodsButtonTableViewCell") as! AddFoodsButtonTableViewCell
        cell.searchButton.imageView?.image = UIImage(named: "SearchIcon")
        cell.searchButton.addTarget(self, action: #selector(searchSelected), for: UIControl.Event.touchUpInside)
        cell.cameraButton.imageView?.image = UIImage(named: "CameraIcon")
        cell.cameraButton.addTarget(self, action: #selector(cameraSelected), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc func cameraSelected(_ sender: Any) {
        
    }
    
    @objc func searchSelected(_ sender: Any) {
        let view: ConfirmDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        
        view.yesAction = {
//            let id: Int64 = self.labelList[self.labelIndex].taskList[indexPath.row].ID
//
//            var listIndex = self.listList.lastIndex(where: {$0.TaskID == id})
//            while listIndex != nil {
//                self.listList.remove(at: listIndex!)
//                listIndex = self.listList.lastIndex(where: {$0.TaskID == id})
//            }
//
//            _ = MainViewController.Database.DeleteTask(id: id)
//            self.taskList.remove(at: self.taskList.lastIndex(where: {$0.ID == id})!)
//            self.labelList[self.labelIndex].taskList.remove(at: indexPath.row)
//            tableView.reloadData()
            //                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            SwiftMessages.hide()
        }
        
        view.cancelAction = {
            SwiftMessages.hide()
        }
    }
}

