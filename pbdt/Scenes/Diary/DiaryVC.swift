//
//  DiaryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/2/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import DZNEmptyDataSet

class DiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logBtn: UIButton!
    
    var navDateView = DateView()
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupButtons()
        setupNotfications()
        setupNavigationBar()
    }
    
    // setups
    
    func setupNavigationBar() {
        
        navDateView.view.backgroundColor = .clear
        navDateView.dateLbl.textColor = UIColor.brandWhite()
        navDateView.dateLbl.font = UIFont.navigationTitle()
        navDateView.updateAfterDateChange()
        
        navDateView.parentVc = "DiaryVC"
        navDateView.diaryVc = self
        
        navigationItem.titleView = navDateView
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setupViews() {
        
        //view.backgroundColor = UIColor.mainViewBackground()
        view.backgroundColor = UIColor.brandWhite()
    }
    
    func setupTableView() {
        
        let nib = UINib(nibName: "DiaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DiaryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        appDelegate.loadFoods()
    }
    
    func setupButtons() {
        
        logBtn.setTitle("Log a Food", for: .normal)
        logBtn.backgroundColor = UIColor.actionButtonBackground()
        logBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        logBtn.titleLabel?.font = UIFont.actionButtonText()
        let height = logBtn.frame.height
        logBtn.layer.cornerRadius = height / 2
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFoodModification), name: NSNotification.Name("FoodModification"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterDateChange() {
        
        print("updateAfterDateChange: DiaryVC")
        //dateView.updateAfterDateChange()
        
        navDateView.updateAfterDateChange()
        
        tableView.reloadData()
        
        if appDelegate.diaryEntries.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func updateAfterFoodModification() {
        
        print("updateAfterFoodModification")
        appDelegate.loadFoods()
        tableView.reloadData()
        
        if appDelegate.diaryEntries.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.diaryEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        let entry = appDelegate.diaryEntries[indexPath.row]
        //print("Entry: \(entry)")
        
        if let name = entry.name {
            cell.nameLbl.text = "\(name.capitalized)"
        }
        
        if let variety = entry.variety {
            
            let servingsT = entry.servingsT
            
            if servingsT == 1 {
                cell.detailLbl.text = "\(variety.capitalized), \(servingsT) serving"
            } else {
                cell.detailLbl.text = "\(variety.capitalized), \(servingsT) servings"
            }
            
            if servingsT.isInt() {
                if servingsT == 1 {
                    cell.detailLbl.text = "\(variety.capitalized), \(Int(servingsT)) serving"
                } else {
                    cell.detailLbl.text = "\(variety.capitalized), \(Int(servingsT)) servings"
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let entry = appDelegate.diaryEntries[indexPath.row]
        presentUpdateDiaryEntryVC(entry)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
            
            let alert = UIAlertController(title: "Are you sure you want to delete this entry", message: "", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                print("delete tapped")
                
                if let food = appDelegate.diaryEntries[indexPath.row] as? Food {
                    self.deleteFood(food: food, indexPathRow: indexPath.row)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
            
            
        return [deleteAction]
    }
    
    // empty data set
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return appDelegate.diaryEntries.count == 0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "No diary entries"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetTitle(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "Food you log will appear here"
        let attributes = [NSAttributedString.Key.font: UIFont.emptyDataSetDescription(),
                          NSAttributedString.Key.foregroundColor: UIColor.brandGreyDark()]
        return NSAttributedString(string: string, attributes: attributes)
    }
    
    // MARK: - actions
    
    @IBAction func logBtn_clicked(_ sender: Any) {
        
        goToAddDiaryEntryVC()
    }
    
    func presentUpdateDiaryEntryVC(_ entry: Food) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateDiaryEntryVC") as! UpdateDiaryEntryVC
        vc.entry = entry
        vc.previousVC = "DiaryVC"
        print("entry variety: \(entry.variety)")
        switch entry.variety {
        case "recipe":
            vc.updateType = "recipe"
        default:
            vc.updateType = "item"
        }
        self.present(vc, animated: true)
    }
    
    func deleteFood(food: Food, indexPathRow: Int) {
        
        print("deleteFood")
        
        let id = "\(food.objectId!)"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "http://localhost:3000/v1/foods/\(id)"
        
        let params = ["food": [
            "id": id
            ]
        ]
        
        print("params: \(params)")
        print("url: \(url)")
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                
                do {
                    try context.delete(food)
                    try context.save()
                    appDelegate.loadFoods()
                    self.tableView.reloadData()
                } catch {
                    print("errors: \(error)")
                }
                
                /*
                if let JSON = response.result.value as? [String: AnyObject] {
                    if let errors = JSON["error"] as? [String: AnyObject] {
                        appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
                    } else {
                        do {
                            try context.delete(food)
                            try context.save()
                            appDelegate.loadFoods()
                            self.tableView.reloadData()
                        } catch {
                            print("errors: \(error)")
                        }
                    }
                }
                */
                
                appDelegate.showInfoView(message: UIMessages.kEntryDeleted, color: UIColor.popUpSuccess())
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
        }
    }
    
    // MARK: - navigation
    
    func goToAddDiaryEntryVC() {
        
//        let backItem = UIBarButtonItem()
//        backItem.title = ""
//        navigationItem.backBarButtonItem = backItem
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddDiaryEntryVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
