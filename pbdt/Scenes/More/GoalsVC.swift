//
//  GoalsVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 4/26/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import NVActivityIndicatorView

class GoalsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateBtn: UIButton!
    
    var spinner: NVActivityIndicatorView!
    var toolbar: UIToolbar!
    
    var namesServings: [String]!
    var goalsServings: [Double]!
    var namesMacros: [String]!
    var goalsMacros: [Double]!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValues()
        setupToolbar()
        setupViews()
        setupTableView()
        setupButtons()
        setupNavigationBar()
        setupSpinner()
    }
    
    // setups
    
    func setInitialValues() {
        
        namesServings = StaticLists.servingsNameArray
        namesMacros = StaticLists.macrosNameArray
        
        if let user = appDelegate.currentUser {
            goalsServings = [
                user.beansG,
                user.berriesG,
                user.otherFruitsG,
                user.cruciferousVegetablesG,
                user.greensG,
                user.otherVegetablesG,
                user.flaxseedsG,
                user.nutsG,
                user.turmericG,
                user.wholeGrainsG,
                user.otherSeedsG
            ]
            
            goalsMacros = [
                user.calsG,
                user.fatG,
                user.carbsG,
                user.proteinG
            ]
        }
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor.mainViewBackground()
        
        segmentedControlView.parentVc = "GoalsVC"
        segmentedControlView.goalsVc = self
    }
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "GoalsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "GoalsCell")
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 76, right: 0)
        tableView.contentInset = insets
        
        tableView.tableFooterView = UIView()
    }
    
    func setupButtons() {
        
        updateBtn.setTitle("Update My Goals", for: .normal)
        updateBtn.backgroundColor = UIColor.actionButtonBackground()
        updateBtn.setTitleColor(UIColor.actionButtonText(), for: .normal)
        updateBtn.titleLabel?.font = UIFont.actionButtonText()
        updateBtn.layer.shadowColor = UIColor.brandGreyDark().cgColor
        updateBtn.layer.shadowOffset = ButtonConstants.shadowOffset
        updateBtn.layer.shadowOpacity = ButtonConstants.shadowOpacity
        let height = updateBtn.frame.height
        updateBtn.layer.cornerRadius = height / 2
    }
    
    func setupNavigationBar() {
        
        print("setupNavigationBar: start")
        
        navigationItem.title = "Goals"
        
        let defaultBtn = UIBarButtonItem(title: "Defaults", style: .plain, target: self, action: #selector(self.setToDefaults))
        self.navigationItem.rightBarButtonItem = defaultBtn
    }
    
    func setupSpinner() {
        spinner = NVActivityIndicatorView(frame: ActivityIndicatorConstants.frame, type: ActivityIndicatorConstants.type, color: ActivityIndicatorConstants.color, padding: nil)
        spinner.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
    }
    
    func setupToolbar() {
        
        toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.isUserInteractionEnabled = true
        toolbar.tintColor = UIColor.toolbarText()
        toolbar.barTintColor = UIColor.toolbarBackground()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.sizeToFit()
    }
    
    @objc func doneClicked() {
        // end editing
        view.endEditing(true)
    }
    
    // update
    
    @objc func setToDefaults() {
        
        print("setToDefaults")
        
        let alert = UIAlertController(title: "Are you sure you want to restore default values?", message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Defaults", style: .default, handler: { (action) in
            print("Defaults tapped")
            
            self.goalsServings[0] = 3
            self.goalsServings[1] = 1
            self.goalsServings[2] = 3
            self.goalsServings[3] = 1
            self.goalsServings[4] = 2
            self.goalsServings[5] = 2
            self.goalsServings[6] = 1
            self.goalsServings[7] = 1
            self.goalsServings[8] = 1
            self.goalsServings[9] = 3
            self.goalsServings[10] = 1
            
            self.goalsMacros[0] = 2000
            self.goalsMacros[1] = 78
            self.goalsMacros[2] = 250
            self.goalsMacros[3] = 75
            
            self.updateUserGoals()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalsCell", for: indexPath) as! GoalsCell
        
        cell.goalTxt.delegate = self
        cell.goalTxt.inputAccessoryView = toolbar
        
        switch self.segmentedControlView.segmentedControl.selectedSegmentioIndex {
        case 0:
            let name = namesServings[indexPath.row]
            let goalServing = goalsServings[indexPath.row]
            
            cell.nameLbl.text = name
            cell.goalTxt.text = "\(goalServing)"
            if goalServing.isInt() {
                cell.goalTxt.text = "\(Int(goalServing))"
            }
            
            cell.goalTxt.tag = 900 + indexPath.row
        case 1:
            let name = namesMacros[indexPath.row]
            let goalServing = goalsMacros[indexPath.row]
            
            cell.nameLbl.text = name
            cell.goalTxt.text = "\(goalServing)"
            if goalServing.isInt() {
                cell.goalTxt.text = "\(Int(goalServing))"
            }
            
            cell.goalTxt.tag = 800 + indexPath.row
        default:
            print("d")
        }
        
        return cell
    }
    
    // text fields
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        print("textField.tag: \(textField.tag)")
        
        if ("\(textField.text)").dotsCheck() {
            appDelegate.showInfoView(message: UIMessages.kInputFormatIncorrect, color: UIColor.popUpFailure())
            return false
        }
        
        if textField.text == "" {
            appDelegate.showInfoView(message: UIMessages.kInputBlank, color: UIColor.popUpFailure())
            return false
        }
        
        let updatedGoal = ((textField.text! as NSString).doubleValue).roundToPlaces(places: 1)
        
        switch textField.tag {
            
        case 900:
            goalsServings[0] = updatedGoal
        case 901:
            goalsServings[1] = updatedGoal
        case 902:
            goalsServings[2] = updatedGoal
        case 903:
            goalsServings[3] = updatedGoal
        case 904:
            goalsServings[4] = updatedGoal
        case 905:
            goalsServings[5] = updatedGoal
        case 906:
            goalsServings[6] = updatedGoal
        case 907:
            goalsServings[7] = updatedGoal
        case 908:
            goalsServings[8] = updatedGoal
        case 909:
            goalsServings[9] = updatedGoal
        case 910:
            goalsServings[10] = updatedGoal
            
        case 800:
            goalsMacros[0] = updatedGoal
        case 801:
            goalsMacros[1] = updatedGoal
        case 802:
            goalsMacros[2] = updatedGoal
        case 803:
            goalsMacros[3] = updatedGoal
            
        default:
            print("d")
        }
        
        textField.text = "\(updatedGoal)"
        
        if updatedGoal.isInt() {
            textField.text = "\(Int(updatedGoal))"
        }
        
        return true
    }
    
    // notifications
    
    func postNotificationUserGoalsModification() {
        //print("postNotificationUserGoalsModification")
        NotificationCenter.default.post(name: NSNotification.Name("UserGoalsModification"), object: nil)
    }
    
    // MARK: - actions
    
    func startSpinner() {
        
        self.view.addSubview(spinner)
        spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopSpinner() {
        self.view.isUserInteractionEnabled = true
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
    
    func updateUserGoals() {
        
        self.startSpinner()
        
        //print("updateUserGoals: start")
        
        let id = "\(appDelegate.currentUser.objectId!)"
        let beansG = "\(goalsServings[0])"
        let berriesG = "\(goalsServings[1])"
        let otherFruitsG = "\(goalsServings[2])"
        let cruciferousVegetablesG = "\(goalsServings[3])"
        let greensG = "\(goalsServings[4])"
        let otherVegetablesG = "\(goalsServings[5])"
        let flaxseedsG = "\(goalsServings[6])"
        let nutsG = "\(goalsServings[7])"
        let turmericG = "\(goalsServings[8])"
        let wholeGrainsG = "\(goalsServings[9])"
        let otherSeedsG = "\(goalsServings[10])"
        let calsG = "\(goalsMacros[0])"
        let fatG = "\(goalsMacros[1])"
        let carbsG = "\(goalsMacros[2])"
        let proteinG = "\(goalsMacros[3])"
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "\(baseUrl)/v1/users/\(id)"
        let params = ["user": [
            "beans_g": beansG,
            "berries_g": berriesG,
            "other_fruits_g": otherFruitsG,
            "cruciferous_vegetables_g": cruciferousVegetablesG,
            "greens_g": greensG,
            "other_vegetables_g": otherVegetablesG,
            "flaxseeds_g": flaxseedsG,
            "nuts_g": nutsG,
            "turmeric_g": turmericG,
            "whole_grains_g": wholeGrainsG,
            "other_seeds_g": otherSeedsG,
            "cals_g": calsG,
            "fat_g": fatG,
            "carbs_g": carbsG,
            "protein_g": proteinG
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
                if let JSON = response.result.value as? [String: AnyObject] {
                    if let user = User.findOrCreateFromJSON(JSON, context: context) {
                        appDelegate.currentUser = user
                        self.setInitialValues()
                        self.tableView.reloadData()
                        appDelegate.showInfoView(message: UIMessages.kGoalsUpdated, color: UIColor.popUpSuccess())
                        self.postNotificationUserGoalsModification()
                        self.goToNavigationRoot()
                        self.goToHome()
                    }
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
            
            self.stopSpinner()
        }
    }
    
    @IBAction func updateBtn_clicked(_ sender: Any) {
        self.view.endEditing(true)
        updateUserGoals()
    }
    
    // MARK: - navigation
    
    func goToHome() {
        self.tabBarController?.selectedIndex = 0
    }
    
    func goToNavigationRoot() {
        navigationController?.popToRootViewController(animated: true)
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
