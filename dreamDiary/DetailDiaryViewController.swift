import UIKit
import RealmSwift

class DetailDiaryViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    // declare realm
    let realm = try! Realm()
    var dreamList: Results<DreamsModel>!
    var dailyDream = DreamsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmからデータ取得
        do {
            dreamList = realm.objects(DreamsModel.self)
        }
        titleLabel.text = dailyDream.title
        bodyLabel.text = dailyDream.body
    }
    
}
