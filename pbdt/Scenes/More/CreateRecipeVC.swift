//
//  CreateRecipeVC.swift
//  pbdt
//
//  Created by Andrew M Levy on 5/1/19.
//  Copyright © 2019 Andrew-M-Levy. All rights reserved.
//

import UIKit
import Alamofire

class CreateRecipeVC: UIViewController, UITextFieldDelegate {

    // MARK: - objects and vars
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var totalServingsLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var totalServingsTxt: UITextField!
    
    var recipe: Recipe!
    var recipeName: String!
    var recipeTotalServings: String!
    
    // MARK: - functions
    
    // lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        nameTxt.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        setupViews()
        setupLabels()
        setupTextFields()

    }
    
    // setups
    
    func setupNavigation() {
        
        //let nextBtn = UIBarButtonItem(image: UIImage.nextArrow(), style: .plain, target: self, action: #selector(nextBtn_clicked))
        let nextBtn = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBtn_clicked))
        self.navigationItem.rightBarButtonItem = nextBtn
        
    }
    
    func setupViews() {
        
        self.view.backgroundColor = UIColor.mainViewBackground()
        topView.backgroundColor = UIColor.mainViewBackground()
    }
    
    func setupLabels() {
        
        nameLbl.text = "Name:"
        nameLbl.textColor = UIColor.brandBlack()
        nameLbl.font = UIFont.large()
        
        totalServingsLbl.text = "Total Servings:"
        totalServingsLbl.textColor = UIColor.brandBlack()
        totalServingsLbl.font = UIFont.large()
    }
    
    func setupTextFields() {
        
        nameTxt.placeholder = "Name your recipe"
        nameTxt.textColor = UIColor.brandPrimary()
        nameTxt.font = UIFont.large()
        nameTxt.delegate = self
        nameTxt.tag = 0
        nameTxt.borderStyle = .none
        
        totalServingsTxt.placeholder = "Serves how many people?"
        totalServingsTxt.textColor = UIColor.brandPrimary()
        totalServingsTxt.font = UIFont.large()
        totalServingsTxt.delegate = self
        totalServingsTxt.tag = 1
        totalServingsTxt.borderStyle = .none
    }
    
    // text fields
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text == "" {
            appDelegate.showInfoView(message: UIMessages.kInputBlank, color: UIColor.popUpFailure())
            return false
        }
        
        switch textField.tag {
        case 0:
            print("0")
            self.recipeName = "\(textField.text!)"
        case 1:
            print("1")
            
            if ("\(textField.text)").dotsCheck() {
                appDelegate.showInfoView(message: UIMessages.kInputFormatIncorrect, color: UIColor.popUpFailure())
                return false
            }
            
            if textField.text == "0" || textField.text == "0.0" {
                appDelegate.showInfoView(message: UIMessages.kInputZero, color: UIColor.popUpFailure())
                return false
            }
            
            self.recipeTotalServings = "\(textField.text!)"
        default:
            print("d")
        }
        
        return true
    }
    
    // notifications
    
    func postNotificationRecipeChange() {
        print("postNotificationRecipeChange")
        NotificationCenter.default.post(name: NSNotification.Name("RecipeChanged"), object: nil)
    }
    
    // MARK: - actions
    
    @objc func nextBtn_clicked() {
        
        print("nextBtn_clicked")
        
        if nameTxt.text!.isEmpty || totalServingsTxt.text!.isEmpty {
            
            nameTxt.attributedPlaceholder = NSAttributedString(string: "Name your recipe", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            totalServingsTxt.attributedPlaceholder = NSAttributedString(string: "Serves how many people?", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])
            
            return
        }
        
        self.view.endEditing(true)
        
        createRecipe()
    }
    
    func createRecipe() {
        
        print("createRecipe")
        
        let email = "\(appDelegate.currentUser.email!)"
        let authenticationToken = "\(appDelegate.currentUser.authenticationToken!)"
        
        let url = "http://localhost:3000/v1/recipes"
        
        let params = ["recipe": [
            "name": "\(recipeName!)",
            "servings": "\(recipeTotalServings!)"
            ]
        ]
        
        let headers: [String:String] = [
            "X-USER-EMAIL": email,
            "X-USER-TOKEN": authenticationToken,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            //print("response: \(response)")
            
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String: AnyObject] {
                    self.recipe = Recipe.findOrCreateFromJSON(JSON, context: context)
                    print("recipe.objectId: \(self.recipe.objectId)")
                    self.postNotificationRecipeChange()
                    self.goToUpdateRecipeVC(recipe: self.recipe)
                }
            case .failure(let error):
                print("response failure: \(error)")
                appDelegate.showInfoView(message: UIMessages.kErrorGeneral, color: UIColor.popUpFailure())
            }
        }
    }
    
    func goToUpdateRecipeVC(recipe: Recipe) {
        print("goToUpdateRecipeVC")
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "UpdateRecipeVC") as! UpdateRecipeVC
        vc.recipe = self.recipe
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - navigation

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
