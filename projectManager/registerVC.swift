//
//  registerVC.swift
//  projectManager
//
//  Created by 黃恩祐 on 2018/5/29.
//  Copyright © 2018年 ENYUHUANG. All rights reserved.
//

import UIKit

class registerVC: UIViewController {
    
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func doRegister(_ sender: Any) {
        
        guard let account = accountTextField.text,
            let password = passwordTextField.text,
            let name = nameTextField.text,
            let ID = IDTextField.text,
            let address = addressTextField.text,
            let phone = phoneTextField.text,
            let cell = cellphoneTextField.text,
            let mail = mailTextField.text else { return }
        
        if account != "" && password != "" && name != "" {
            self.registerRequest(account: account, password: password, name: name, ID: ID, address: address, phone: phone, cellphone: cell, mail: mail) { (isSucceed, message) in
                if isSucceed {
                    print("succeed")
                    //                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! loginVC
                    let alert = UIAlertController(title: "註冊成功", message: nil, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "確認", style: .default, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(okBtn)
                    self.presentAlert(alert, animated: true)
                }else {
                    print(message)
                    self.showAlert(title: "\(message)", message: nil)
                }
            }
        }else {
            self.showAlert(title: "帳號、密碼、姓名為必填欄位，請填寫完整。", message: nil)
        }
        
    }
    
}
