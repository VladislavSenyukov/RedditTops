//
//  ViewController.swift
//  RedditTops
//
//  Created by Vladislav Senyukov on 06.06.17.
//  Copyright © 2017 Vladislav Senyukov. All rights reserved.
//

import UIKit

class RTLoginViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    weak var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    }

    @IBAction func didTapBackground(_ sender: UITapGestureRecognizer) {
        activeField?.resignFirstResponder()
    }
    
    func login() {
        let login = loginField.text
        let pass = passwordField.text
        let alert = UIAlertController(title: "Error", message: "Please, check correctness of your login data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        if (validateAuthData(login: login, pass: pass)) {
            activeField?.resignFirstResponder()
            spinner.startAnimating()
            RTAppFacade.shared.login(login: login!, pass: pass!, completion: {[unowned self] (success: Bool) -> () in
                self.spinner.stopAnimating()
                if success {
                    
                } else {
                    self.show(alert, sender: self)
                }
            })
        } else {
            show(alert, sender: self)
        }
    }
    
    func validateAuthData(login: String?, pass: String?) -> Bool {
        // simplified validation
        guard
            let aLogin = login,
            let aPass = pass
        else {
            return false
        }
        return aLogin.characters.count > 0 && aPass.characters.count > 0
    }

}

extension RTLoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === loginField {
            passwordField.becomeFirstResponder()
        } else if textField === passwordField {
            login()
        }
        return true
    }
}

