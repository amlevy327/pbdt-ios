//
//  UpdateDiaryEntryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/5/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Alamofire
import Segmentio

class UpdateDiaryEntryVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - objects and vars
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var totalServingSizeLbl: UILabel!
    @IBOutlet weak var servingSizeLbl: UILabel!
    @IBOutlet weak var numberOfServingsLbl: UILabel!
    @IBOutlet weak var servingSizeTxt: UITextField!
    @IBOutlet weak var numberOfServingsTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    
    var previousVC = ""
    var namesServings: [String]!
    var amountsServings: [Double]!
    var namesMacros: [String]!
    var amountsMacros: [Double]!
    
    var entry: Food!
    var ssAmtVolT_updated: Double = 0.0
    var ssAmtWtT_updated: Double = 0.0
    var servingsT_updated: Double = 0.0
    
    var item: Item!
    var ssAmtVolT_new: Double = 0.0
    var ssAmtWtT_new: Double = 0.0
    var servingsT_new: Double = 1.0
    
    // MARK: - functions
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("entry: \(entry)")
        //print("previousVC: \(previousVC)")
        
        setInitialValues()
        
        setupViews()
        setupLabels()
        setupTextFields()
        setupButtons()
        setupTableView()
    }
    
    // setups
    
    func setInitialValues() {
        
        namesServings = StaticLists.servingsNameArray
        namesMacros = StaticLists.macrosNameArray
        
        switch previousVC {
        case "DiaryVC":
             print("setInitialValues, previousVC = DiaryVC")
             
             amountsServings = [
                entry.beansT,
                entry.berriesT,
                entry.otherFruitsT,
                entry.cruciferousVegetablesT,
                entry.greensT,
                entry.otherVegetablesT,
                entry.flaxseedsT,
                entry.nutsT,
                entry.turmericT,
                entry.wholeGrainsT,
                entry.otherSeedsT
             ]
             
             amountsMacros = [
                entry.calsT,
                entry.fatT,
                entry.carbsT,
                entry.proteinT
             ]
             
             ssAmtWtT_updated = entry.ssAmtWtT
             ssAmtVolT_updated = entry.ssAmtVolT
             servingsT_updated = entry.servingsT
        case "AddDiaryEntryVC":
            print("setInitialValues, previousVC = AddDiaryEntryVC")
            
            amountsServings = [
                item.beans,
                item.berries,
                item.otherFruits,
                item.cruciferousVegetables,
                item.greens,
                item.otherVegetables,
                item.flaxseeds,
                item.nuts,
                item.turmeric,
                item.wholeGrains,
                item.otherSeeds
            ]
            
            amountsMacros = [
                item.cals,
                item.fat,
                item.carbs,
                item.protein
            ]
            
            ssAmtWtT_new = item.ssAmtWt
            ssAmtVolT_new = item.ssAmtVol
        default:
            print("setInitialValues, previousVC = default")
        }
    }
    
    func setupViews() {
        
        topView.backgroundColor = .yellow
        
        segmentedControlView.parentVc = "UpdateDiaryEntryVC"
        segmentedControlView.updateDiaryEntryVc = self
    }
    
    func setupLabels() {
        
        servingSizeLbl.text = "Serving size"
        numberOfServingsLbl.text = "Number of servings"
        
        switch previousVC {
        case "DiaryVC":
            print("setupLabels, previousVC = DiaryVC")
            
            if let name = entry.name {
                nameLbl.text = "\(name)"
            }
            
            if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
                totalServingSizeLbl.text = "\(ssAmtVolT_updated) \(ssUnitVolT), \(ssAmtWtT_updated) \(ssUnitWtT)"
            }
        case "AddDiaryEntryVC":
            print("setupLabels, previousVC = AddDiaryEntryVC")
            
            if let name = item.name {
                nameLbl.text = "\(name)"
            }
            
            if let ssUnitVol = item.ssUnitVol, let ssUnitWt = item.ssUnitWt {
                totalServingSizeLbl.text = "\(ssAmtVolT_new) \(ssUnitVol), \(ssAmtWtT_new) \(ssUnitWt)"
            }
        default:
            print("setupLabels, previousVC = default")
        }
    }
    
    func setupTextFields() {
        
        servingSizeTxt.tag = 900
        servingSizeTxt.borderStyle = .none
        servingSizeTxt.isUserInteractionEnabled = false
        
        numberOfServingsTxt.tag = 901
        numberOfServingsTxt.borderStyle = .none
        numberOfServingsTxt.isUserInteractionEnabled = true
        numberOfServingsTxt.delegate = self
        
        switch previousVC {
        case "DiaryVC":
            print("setupTextFields, previousVC = DiaryVC")
            
            let ssAmtVol = entry.ssAmtVolT / entry.servingsT
            let ssAmtWt = entry.ssAmtWtT / entry.servingsT
            if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
                servingSizeTxt.text = "\(ssAmtVol) \(ssUnitVolT), \(ssAmtWt) \(ssUnitWtT)"
            }
            
            numberOfServingsTxt.text = "\(servingsT_updated)"
        case "AddDiaryEntryVC":
            print("setupTextFields, previousVC = AddDiaryEntryVC")
            
            if let ssUnitVol = item.ssUnitVol, let ssUnitWt = item.ssUnitWt {
                servingSizeTxt.text = "\(ssAmtVolT_new) \(ssUnitVol), \(ssAmtWtT_new) \(ssUnitWt)"
            }
            
            numberOfServingsTxt.text = "\(servingsT_new)"
        default:
            print("setupTextFields, previousVC = default")
        }
    }
    
    func setupButtons() {
        
        switch previousVC {
        case "DiaryVC":
            print("setupButtons, previousVC = DiaryVC")
            
            actionBtn.setTitle("Update", for: .normal)
        case "AddDiaryEntryVC":
            print("setupButtons, previousVC = AddDiaryEntryVC")
            
            actionBtn.setTitle("Add To Diary", for: .normal)
        default:
            print("setupButtons, previousVC = default")
        }
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "UpdateDiaryEntryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpdateDiaryEntryCell")
        
        tableView.tableFooterView = UIView()
    }
    
    // table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            return namesServings.count
        case 1:
            return namesMacros.count
        default:
            print("d")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDiaryEntryCell", for: indexPath) as! UpdateDiaryEntryCell
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            let name = namesServings[indexPath.row]
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountsServings[indexPath.row])"
        case 1:
            let name = namesMacros[indexPath.row]
            cell.nameLbl.text = name
            cell.amountLbl.text = "\(amountsMacros[indexPath.row])"
        default:
            print("d")
        }
        
        return cell
    }
    
    // text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText : NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string) as NSString
        
        switch previousVC {
        case "DiaryVC":
            print("shouldChangeCharactersIn, previousVC = DiaryVC")
            
            if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
                self.ssAmtVolT_updated = entry.ssAmtVolT / entry.servingsT * txtAfterUpdate.doubleValue
                self.ssAmtWtT_updated = entry.ssAmtWtT / entry.servingsT * txtAfterUpdate.doubleValue
                self.servingsT_updated = txtAfterUpdate.doubleValue
                totalServingSizeLbl.text = "\(self.ssAmtVolT_updated) \(ssUnitVolT), \(self.ssAmtWtT_updated) \(ssUnitWtT)"
                
            }
            
            amountsServings = [
                (entry.beansT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.berriesT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.otherFruitsT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.cruciferousVegetablesT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.greensT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.otherVegetablesT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.flaxseedsT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.nutsT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.turmericT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.wholeGrainsT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.otherSeedsT / entry.servingsT) * txtAfterUpdate.doubleValue
            ]
            
            amountsMacros = [
                (entry.calsT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.fatT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.carbsT / entry.servingsT) * txtAfterUpdate.doubleValue,
                (entry.proteinT / entry.servingsT) * txtAfterUpdate.doubleValue
            ]
            
            //print("amountsServings after update: \(amountsServings)")
            //print("self.ssAmtWtT_updated: \(self.ssAmtWtT_updated)")
            //print("self.ssAmtVolT_updated: \(self.ssAmtVolT_updated)")
        case "AddDiaryEntryVC":
            print("shouldChangeCharactersIn, previousVC = AddDiaryEntryVC")
            
            if let ssUnitVol = item.ssUnitVol, let ssUnitWt = item.ssUnitWt {
                self.ssAmtVolT_new = item.ssAmtVol * txtAfterUpdate.doubleValue
                self.ssAmtWtT_new = item.ssAmtWt * txtAfterUpdate.doubleValue
                self.servingsT_new = txtAfterUpdate.doubleValue
                totalServingSizeLbl.text = "\(self.ssAmtVolT_new) \(ssUnitVol), \(self.ssAmtWtT_new) \(ssUnitWt)"
                
            }
            
            amountsServings = [
                item.beans * txtAfterUpdate.doubleValue,
                item.berries * txtAfterUpdate.doubleValue,
                item.otherFruits * txtAfterUpdate.doubleValue,
                item.cruciferousVegetables * txtAfterUpdate.doubleValue,
                item.greens * txtAfterUpdate.doubleValue,
                item.otherVegetables * txtAfterUpdate.doubleValue,
                item.flaxseeds * txtAfterUpdate.doubleValue,
                item.nuts * txtAfterUpdate.doubleValue,
                item.turmeric * txtAfterUpdate.doubleValue,
                item.wholeGrains * txtAfterUpdate.doubleValue,
                item.otherSeeds * txtAfterUpdate.doubleValue
            ]
            
            amountsMacros = [
                item.cals * txtAfterUpdate.doubleValue,
                item.fat * txtAfterUpdate.doubleValue,
                item.carbs * txtAfterUpdate.doubleValue,
                item.protein * txtAfterUpdate.doubleValue
            ]
            
            //print("self.ssAmtWt_new: \(self.ssAmtWtT_new)")
            //print("self.ssAmtVol_new: \(self.ssAmtVolT_new)")
        default:
            print("shouldChangeCharactersIn, previousVC = default")
        }
        
        tableView.reloadData()
        
        return true
    }
    
    
    // MARK: - actions
    
    func updateFood() {
        
        let id = "\(entry.objectId!)"
        let servingsT = "\(servingsT_updated)"
        let ssAmtWtT = "\(ssAmtWtT_updated)"
        let ssAmtVolT = "\(ssAmtVolT_updated)"
        let beansT = "\(amountsServings[0])"
        let berriesT = "\(amountsServings[1])"
        let otherFruitsT = "\(amountsServings[2])"
        let cruciferousVegetablesT = "\(amountsServings[3])"
        let greensT = "\(amountsServings[4])"
        let otherVegetablesT = "\(amountsServings[5])"
        let flaxseedsT = "\(amountsServings[6])"
        let nutsT = "\(amountsServings[7])"
        let turmericT = "\(amountsServings[8])"
        let wholeGrainsT = "\(amountsServings[9])"
        let otherSeedsT = "\(amountsServings[10])"
        let calsT = "\(amountsMacros[0])"
        let fatT = "\(amountsMacros[1])"
        let carbsT = "\(amountsMacros[2])"
        let proteinT = "\(amountsMacros[3])"
        //let logDate = "\(appDelegate.dateFilter.toString(format: "yyyy-MM-dd"))"
        
        let email = "\(UserDefaults.standard.string(forKey: "email")!)"
        let authenticationToken = "\(UserDefaults.standard.string(forKey: "authenticationToken")!)"
        
        let url = "http://localhost:3000/v1/foods/\(id)"
        let params = ["food": [
            "servings_t": servingsT,
            "ss_amt_wt_t": ssAmtWtT,
            "ss_amt_vol_t": ssAmtVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "other_fruits_t": otherFruitsT,
            "cruciferous_vegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "other_vegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "whole_grains_t": wholeGrainsT,
            "other_seeds_t": otherSeedsT,
            "cals_t": calsT,
            "fat_t": fatT,
            "carbs_t": carbsT,
            "protein_t": proteinT
            ]
        ]
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [[String: AnyObject]] {
                    for food in JSON {
                        Food.findOrCreateFromJSON(food, context: context)
                    }
                }
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("response failure: \(error)")
            }
        }
    }
    
    func newFood() {
        
        let name = "\(item.name!)"
        let variety = "\(item.variety!)"
        let servingsT = "\(servingsT_new)"
        let ssAmtWtT = "\(ssAmtWtT_new)"
        let ssAmtVolT = "\(ssAmtVolT_new)"
        let ssUnitWtT = "\(item.ssUnitWt!)"
        let ssUnitVolT = "\(item.ssUnitVol!)"
        let beansT = "\(amountsServings[0])"
        let berriesT = "\(amountsServings[1])"
        let otherFruitsT = "\(amountsServings[2])"
        let cruciferousVegetablesT = "\(amountsServings[3])"
        let greensT = "\(amountsServings[4])"
        let otherVegetablesT = "\(amountsServings[5])"
        let flaxseedsT = "\(amountsServings[6])"
        let nutsT = "\(amountsServings[7])"
        let turmericT = "\(amountsServings[8])"
        let wholeGrainsT = "\(amountsServings[9])"
        let otherSeedsT = "\(amountsServings[10])"
        let calsT = "\(amountsMacros[0])"
        let fatT = "\(amountsMacros[1])"
        let carbsT = "\(amountsMacros[2])"
        let proteinT = "\(amountsMacros[3])"
        let logDate = "\(appDelegate.dateFilter.toString(format: "yyyy-MM-dd"))"
        
        let email = "\(UserDefaults.standard.string(forKey: "email")!)"
        let authenticationToken = "\(UserDefaults.standard.string(forKey: "authenticationToken")!)"
        
        let url = "http://localhost:3000/v1/foods"
        let params = ["food": [
            "name": name,
            "variety": variety,
            "servings_t": servingsT,
            "ss_amt_wt_t": ssAmtWtT,
            "ss_amt_vol_t": ssAmtVolT,
            "ss_unit_wt_t": ssUnitWtT,
            "ss_unit_vol_t": ssUnitVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "other_fruits_t": otherFruitsT,
            "cruciferous_vegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "other_vegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "whole_grains_t": wholeGrainsT,
            "other_seeds_t": otherSeedsT,
            "cals_t": calsT,
            "fat_t": fatT,
            "carbs_t": carbsT,
            "protein_t": proteinT,
            "log_date": logDate
            ]
        ]
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            //print(response)
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    //print("JSON: \(JSON)")
                    Food.findOrCreateFromJSON(JSON, context: context)
                }
                
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print("response failure: \(error)")
            }
        }
    }
    
    @IBAction func actionBtn_clicked(_ sender: Any) {
        
        switch previousVC {
        case "DiaryVC":
            print("actionBtn_clicked, previousVC = DiaryVC")
            updateFood()
        case "AddDiaryEntryVC":
            print("actionBtn_clicked, previousVC = AddDiaryEntryVC")
            newFood()
        default:
            print("actionBtn_clicked, previousVC = default")
        }
    }
    
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - navigation
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
