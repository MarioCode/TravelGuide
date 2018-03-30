//
//  LoginViewController.swift
//  TravelGuide
//
//  Created by Anton Makarov on 24.03.2018.
//  Copyright © 2018 Anton Makarov. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SCLAlertView

class LoginViewController: UIViewController, ValidityFields {

    @IBOutlet var loginTextField: SkyFloatingLabelTextField!
    @IBOutlet var passwordTextField: SkyFloatingLabelTextField!
    
    @IBOutlet var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        guard let login = loginTextField.text, isLoginValid(login)  else {
            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            alertView.addButton("Понятно") { }
            alertView.showWarning("Упс", subTitle: "Кажется вы допустили ошибку в логине")
            return
        }
        
        guard let password = passwordTextField.text, isPasswordValid(password) else {
            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            alertView.addButton("Понятно") { }
            alertView.showWarning("Упс", subTitle: "Такой пароль нам не подходит")
            return
        }
        
        let parameters: Json = ["name" : login as AnyObject, "password" : passwordTextField.text  as AnyObject]
        
        APIService.shared.doLogin(with: parameters) { (response, error) in
            let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))

            guard error == nil || response != nil else {
                alertView.addButton("Попробовать позже") { }
                alertView.showError("Ошибка сервера", subTitle: "Сервер выключен или ведутся тех.работы. ")
                return
            }
            
            if response!["status"] as? String == "error" {
                alertView.addButton("Еще разок") { }
                alertView.showError("Ошибка авторизации", subTitle: "Неправильный логин / пароль")
                return
            }
            
            if response!["status"] as? String == "success" {
                let token = response!["data"] as! Json
                UserDefaults.standard.setUserToken(token: token["token"] as! String)
                UserDefaults.standard.setIsLoggedIn(value: true)
                self.navigationToChooseCityView()
            }
        }
    }
    
    func navigationToChooseCityView() {
        let citiesVC = UIStoryboard.loadViewController(from: "Main", named: "CitiesBoard") as? CityListViewController
        self.present(citiesVC!, animated: true, completion: nil)
    }
    
    @IBAction func cancelAfction(_ sender: Any) {
        self.dismissWindow()
    }
}