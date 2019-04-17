//
//  DiaryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/2/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData

class DiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - objects and vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var dateView: DateView!
    
    //var diaryEntries = [Food]()
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTableView()
        setupButtons()
        setupNotfications()
    }
    
    // setups
    
    func setupViews() {
        
        view.backgroundColor = .cyan
        
        dateView.parentVc = "DiaryVC"
        dateView.diaryVc = self
    }
    
    func setupTableView() {
        
        let nib = UINib(nibName: "DiaryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DiaryCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        dateView.loadFoods()
    }
    
    func setupButtons() {
        
        logBtn.setTitle("Log New Food", for: .normal)
    }
    
    func setupNotfications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterDateChange), name: NSNotification.Name("DateChanged"), object: nil)
    }
    
    // updates
    
    @objc func updateAfterDateChange() {
        
        print("updateAfterDateChange")
        dateView.updateAfterDateChange()
    }
    
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.diaryEntries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        
        let entry = appDelegate.diaryEntries[indexPath.row]
        //print("Entry: \(entry)")
        
        if let id = entry.objectId {
            cell.idLbl.text = "\(id)"
        }
        
        if let name = entry.name {
            cell.nameLbl.text = "\(name.capitalized)"
        }
        
        if let variety = entry.variety {
            
            let servingsT = entry.servingsT
            
            if servingsT.truncatingRemainder(dividingBy: 1) == 0 {
                let servingsTInt = Int(servingsT)
                cell.detailLbl.text = "\(variety.capitalized), \(servingsTInt) servings"
            } else {
                cell.detailLbl.text = "\(variety.capitalized), \(servingsT) servings"
            }
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = appDelegate.diaryEntries[indexPath.row]
        presentUpdateDiaryEntryVC(entry)
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
