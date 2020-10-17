import UIKit
import RealmSwift

class EditingViewController: UIViewController {
    @IBOutlet var titleEditField: UITextField!
    @IBOutlet var bodyEditField: UITextView!
    // declare realm
    let realm = try! Realm()
    var dreamList: Results<DreamsModel>!
    var selectedDreamList: Results<DreamsModel>!
    var dailyDream = DreamsModel()
    var id4edit: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmからデータ取得
        do {
            let realm = try Realm()
            dreamList = realm.objects(DreamsModel.self)
        } catch {
        }
        selectedDreamList = dreamList.filter("%@ =< date AND date < %@", "test")
        
        titleEditField.text = dailyDream.title
        bodyEditField.text = dailyDream.body
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func saveDream(_ sender: Any) {
        // モデルのクラスをインスタンス化
        let dailyDream = DreamsModel()
        // コンテンツを保存
        dailyDream.title = self.titleEditField.text!
        dailyDream.body = self.bodyEditField.text!
        // Realmのdbを取得
        let realm_after = try! Realm()
        // 書き込み
        try! realm_after.write {
            realm_after.add(dailyDream)
        }
        // 画面遷移
        self.navigationController?.popToRootViewController(animated: true)
    }
}
