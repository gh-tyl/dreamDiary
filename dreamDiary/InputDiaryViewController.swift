//
//  InputDiaryViewController.swift
//  dreamDiary
//
//  Created by Tyler Inari on 2020/10/05.
//

import UIKit
import Realm

class InputDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dreamTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Textの設定
        // titleTextField.delegate = self
        // dreamTextView.delegate = self
                
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonPushed(_ sender: UIButton) {
        
    }

}
