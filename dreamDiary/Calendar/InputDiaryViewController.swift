import UIKit
import RealmSwift
import AVFoundation

class InputDiaryViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var bodyTextView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    var dreamList: Results<DreamsModel>!
    // 音楽コントローラ AVAudioPlayerを定義
    var player:AVAudioPlayer = AVAudioPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.setValue(UIColor.yellow, forKey: "textColor")
        datePicker.setValue(false, forKey: "highlightsToday")
//        datePicker.backgroundColor = .white
        // Realmのインスタンスを取得
        let realm = try! Realm()
        self.dreamList = realm.objects(DreamsModel.self)
        //Audioの停止
        player.stop()
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
        // 書き込み
        try! realm_after.write {
            realm_after.add(dailyDream)
        }
        // 画面遷移
        self.navigationController?.popViewController(animated: true)
    }
    
}
