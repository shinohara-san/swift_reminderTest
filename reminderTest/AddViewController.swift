//
//  AddViewController.swift
//  reminderTest
//
//  Created by Yuki Shinohara on 2020/06/08.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    public var completion: ((String, String, Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        bodyField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSaveButton))
    }
    
    @objc func didTapSaveButton(){
        if let titleText = titleField.text, !titleText.isEmpty,
            let bodyText = bodyField.text, !bodyText.isEmpty{
            let targetDate = datePicker.date
            
            completion?(titleText, bodyText, targetDate)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        キーボードを下げる処理
        textField.resignFirstResponder()
        return true
    }

}
