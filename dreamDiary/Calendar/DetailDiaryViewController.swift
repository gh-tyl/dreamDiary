import UIKit
import RealmSwift

class DetailDiaryViewController: UIViewController {
    @IBOutlet var titleEditField: UITextField!
    @IBOutlet var bodyEditField: UITextView!
    // declare realm
    let realm = try! Realm()
    var dailyDream = DreamsModel()
    var dreamId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleEditField.text = dailyDream.title
        bodyEditField.text = dailyDream.body
        dreamId = dailyDream.id
    }
    
    // delegate screen and pass data
    @IBAction func saveDream(_ sender: Any) {
        // モデルのクラスをインスタンス化
        let dailyDream = DreamsModel()
        // コンテンツを保存
        dailyDream.title = self.titleEditField.text!
        dailyDream.body = self.bodyEditField.text!        
        let edited_model = realm.object(ofType: DreamsModel.self, forPrimaryKey: dreamId)
        // Realmのdbを取得
        try! realm.write {
            edited_model?.title = self.titleEditField.text!
            edited_model?.body = self.bodyEditField.text!
        }
        // 画面遷移
        self.navigationController?.popViewController(animated: true)
    }
    
    // delete
    @IBAction func deleteDream(_ sender: Any) {
        // モデルのクラスをインスタンス化
        let dailyDream = DreamsModel()
        // コンテンツを保存
        dailyDream.title = self.titleEditField.text!
        dailyDream.body = self.bodyEditField.text!
        let edited_model = realm.object(ofType: DreamsModel.self, forPrimaryKey: dreamId)
        // Realmのdbを取得
        try! realm.write {
            realm.delete(edited_model!)
        }
        // 画面遷移
        self.navigationController?.popViewController(animated: true)
    }
    
}
