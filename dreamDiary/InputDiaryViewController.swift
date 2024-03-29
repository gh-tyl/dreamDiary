import UIKit
import RealmSwift

class InputDiaryViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    var dreamList: Results<DreamsModel>!
    // primary keyの作成
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmのインスタンスを取得
        let realm = try! Realm()
        self.dreamList = realm.objects(DreamsModel.self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveDream(_ sender: Any) {
        _ = try! Realm()
        // モデルのクラスをインスタンス化
        let dailyDream = DreamsModel()
        // コンテンツを保存
        dailyDream.date = self.datePicker.date
        dailyDream.title = self.titleTextField.text!
        dailyDream.body = self.bodyTextView.text
        // Realmのdbを取得
        let realm_after = try! Realm()
        print("dailyDream", dailyDream)
        // 書き込み
        try! realm_after.write {
            realm_after.add(dailyDream)
        }
        // 画面遷移
        self.navigationController?.popViewController(animated: true)
        
    }
}
