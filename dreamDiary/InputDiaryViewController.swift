//
//  InputDiaryViewController.swift
//  dreamDiary
//
//  Created by Tyler Inari on 2020/10/05.
//

import UIKit
import RealmSwift

class InputDiaryViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dreamTextView: UITextView!
    let realm = try! Realm()
    let dailyDream = DreamsModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonPushed(_ sender: UIButton) {
        try! realm.write {
            realm.add(dailyDream)
        }
    }

}
