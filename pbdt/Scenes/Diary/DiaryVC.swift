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

class DiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var dateView: DateView!
    
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
        //navDateView.dateLbl.text = "Today"
        navDateView.updateAfterDateChange()
        
        navDateView.parentVc = "DiaryVC"
        navDateView.diaryVc = self
        
        navigationItem.titleView = navDateView
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupTableView() {
        
        let nib = UINib(nibName: "DiaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DiaryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        appDelegate.loadFoods()
    }
    
    func setupButtons() {
        
        logBtn.setTitle("Log Food", for: .normal)
        logBtn.backgroundColor = UIColor.actionButtonBackground()
        logBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        logBtn.titleLabel?.font = UIFont.actionButtonText()
        logBtn.layer.borderWidth = CGFloat(2)
        logBtn.layer.borderColor = UIColor.actionButtonBorder().cgColor
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
            
            if appDelegate.checkIfInt(input: servingsT) {
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
                
                if let id = appDelegate.diaryEntries[indexPath.row].objectId {
                    self.deleteFood(objectId: id, indexPathRow: indexPath.row)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
            
            
        return [deleteAction]
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
        self.present(vc, animated: true)
    }
    
    func deleteFood(objectId: NSNumber, indexPathRow: Int) {
        print("deleteFood: start, id = \(objectId)")
        
        let email = "\(UserDefaults.standard.string(forKey: "email")!)"
        let authenticationToken = "\(UserDefaults.standard.string(forKey: "authenticationToken")!)"
        
        let url = "http://localhost:3000/v1/foods/\(objectId)"
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        /*
        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    
                    for food in JSON {
                        Food.findOrCreateFromJSON(food, context: context)
                    }
                    
                    let fetchRequest: NSFetchRequest<Food> = NSFetchRequest(entityName: "Food")
                    fetchRequest.predicate = NSPredicate(format: "objectId = %@", objectId)
                    let foodFetch = try context.fetch(fetchRequest)
                    for food in foodFetch {
                        context.delete(food)
                    }
                    context.save()
                }
            case .failure(let error):
                print("response failure: \(error)")
            }
        }
        */
        /*
        do {
            let fetchRequest = try context.fetch(foodFetch)
            appDelegate.diaryEntries = fetchRequest
        } catch {
            print("Error fetching foods: \(error)")
        }
        */
    }
    
    // MARK: - navigation
    
    func goToAddDiaryEntryVC() {
        
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
