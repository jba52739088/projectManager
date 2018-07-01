//
//  loginVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/28.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class loginVC: UIViewController {
    
    @IBOutlet weak var appLogo: UILabel!
    @IBOutlet weak var copyRight: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var accTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        appLogo.layer.borderColor = UIColor.black.cgColor
        appLogo.layer.borderWidth = 2
        copyRight.layer.borderColor = UIColor.black.cgColor
        copyRight.layer.borderWidth = 2
        loginBtn.layer.cornerRadius = 3
        loginBtn.layer.masksToBounds = true
        registerBtn.layer.masksToBounds = true
        
        self.accTextField.text = "systemadmin"
        self.pwdTextField.text = "123"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func doLogin(_ sender: Any) {
        
        if let acc = self.accTextField.text,
            let pwd = self.pwdTextField.text {
            
            self.loginRequest(account: acc, password: pwd, { (isSucceed) in
                if isSucceed {
                    if let tabbarController = self.storyboard?.instantiateViewController(withIdentifier: "tabbarController") {
                        self.present(tabbarController, animated: true, completion: nil)
                    }
                }else {
                    self.showAlert(title: "帳號或密碼錯誤", message: nil)
                }
            })
        }else {
            self.showAlert(title: "請輸入帳號或密碼", message: nil)
        }
    }
    
    @IBAction func doRegister(_ sender: Any) {
    }
    
    
    
}

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
