//
//  UpdateDiaryEntryVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/5/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Alamofire

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
    @IBOutlet weak var updateBtn: UIButton!
    
    var entry: Food!
    var names: [String]!
    var amounts: [Double]!
    var ssAmtVolT_updated: Double = 0.0
    var ssAmtWtT_updated: Double = 0.0
    var servingsT_updated: Double = 0.0
    
    // MARK: - functions
    
    // lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("entry: \(entry)")
        names = StaticLists.servingsNameArray
        
        amounts = [
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
        ssAmtWtT_updated = entry.ssAmtWtT
        ssAmtVolT_updated = entry.ssAmtVolT
        servingsT_updated = entry.servingsT
        
        setupViews()
        setupLabels()
        setupTextFields()
        setupButtons()
        setupTableView()
    }
    
    // setups
    
    func setupViews() {
        topView.backgroundColor = .yellow
    }
    
    func setupLabels() {
        
        if let name = entry.name {
            nameLbl.text = "\(name)"
        }
        if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
            totalServingSizeLbl.text = "\(entry.ssAmtVolT) \(ssUnitVolT), \(entry.ssAmtWtT) \(ssUnitWtT)"
        }
        servingSizeLbl.text = "Serving size"
        numberOfServingsLbl.text = "Number of servings"
    }
    
    func setupTextFields() {
        
        servingSizeTxt.tag = 900
        servingSizeTxt.borderStyle = .none
        servingSizeTxt.isUserInteractionEnabled = false
        
        numberOfServingsTxt.tag = 901
        numberOfServingsTxt.borderStyle = .none
        numberOfServingsTxt.isUserInteractionEnabled = true
        numberOfServingsTxt.delegate = self
        
        let ssAmtVol = entry.ssAmtVolT / entry.servingsT
        let ssAmtWt = entry.ssAmtWtT / entry.servingsT
        if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
            servingSizeTxt.text = "\(ssAmtVol) \(ssUnitVolT), \(ssAmtWt) \(ssUnitWtT)"
        }
        
        numberOfServingsTxt.text = "\(entry.servingsT)"
    }
    
    func setupButtons() {
        
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
        return names.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDiaryEntryCell", for: indexPath) as! UpdateDiaryEntryCell
        
        let name = names[indexPath.row]
        cell.nameLbl.text = name
        cell.amountLbl.text = "\(amounts[indexPath.row])"
        
        return cell
    }
    
    // text fields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText : NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string) as NSString
        
        if let ssUnitVolT = entry.ssUnitVolT, let ssUnitWtT = entry.ssUnitWtT {
            self.ssAmtVolT_updated = entry.ssAmtVolT / entry.servingsT * txtAfterUpdate.doubleValue
            self.ssAmtWtT_updated = entry.ssAmtWtT / entry.servingsT * txtAfterUpdate.doubleValue
            self.servingsT_updated = txtAfterUpdate.doubleValue
            totalServingSizeLbl.text = "\(self.ssAmtVolT_updated) \(ssUnitVolT), \(self.ssAmtWtT_updated) \(ssUnitWtT)"

        }
        
        amounts = [
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
        
        print("self.ssAmtWtT_updated: \(self.ssAmtWtT_updated)")
        print("self.ssAmtVolT_updated: \(self.ssAmtVolT_updated)")
        
        tableView.reloadData()
        
        return true
    }
    
    
    // MARK: - actions
    
    @IBAction func updateBtn_clicked(_ sender: Any) {
        
        let id = "\(entry.objectId!)"
        let servingsT = "\(servingsT_updated)"
        let ssAmtWtT = "\(ssAmtWtT_updated)"
        let ssAmtVolT = "\(ssAmtVolT_updated)"
        let beansT = "\(amounts[0])"
        let berriesT = "\(amounts[1])"
        let otherFruitsT = "\(amounts[2])"
        let cruciferousVegetablesT = "\(amounts[3])"
        let greensT = "\(amounts[4])"
        let otherVegetablesT = "\(amounts[5])"
        let flaxseedsT = "\(amounts[6])"
        let nutsT = "\(amounts[7])"
        let turmericT = "\(amounts[8])"
        let wholeGrainsT = "\(amounts[9])"
        let otherSeeds = "\(amounts[10])"
        
        let email = "\(UserDefaults.standard.string(forKey: "email")!)"
        let authenticationToken = "\(UserDefaults.standard.string(forKey: "authenticationToken")!)"
        
        let url = "http://localhost:3000/v1/foods/\(id)"
        let params = ["food": [
            "servings_t": servingsT,
            "ssAmtWt_t": ssAmtWtT,
            "ssAmtVol_t": ssAmtVolT,
            "beans_t": beansT,
            "berries_t": berriesT,
            "otherFruits_t": otherFruitsT,
            "cruciferousVegetables_t": cruciferousVegetablesT,
            "greens_t": greensT,
            "otherVegetables_t": otherVegetablesT,
            "flaxseeds_t": flaxseedsT,
            "nuts_t": nutsT,
            "turmeric_t": turmericT,
            "wholeGrains_t": wholeGrainsT,
            "otherSeeds_t": otherSeeds
            ]
        ]

        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        print("url: \(url)")
        print("params: \(params)")
        print("headers: \(headers)")
        
        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            print(response)
            
            switch response.result {
            case .success:
                print("response success")
                if let JSON = response.result.value as? [String: Any] {
                    print("JSON: \(JSON)")
                    appDelegate.saveContext()
                }
            case .failure(let error):
                print("response failure: \(error)")
            }
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
