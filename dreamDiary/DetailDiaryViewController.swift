import UIKit
import RealmSwift

class DetailDiaryViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    // declare realm
    let realm = try! Realm()
    var dreamList: Results<DreamsModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realmからデータ取得
        do {
            let realm = try Realm()
            dreamList = realm.objects(DreamsModel.self)//.filter()
        } catch {
        }
        titleLabel.reloadInputViews()
        bodyLabel.reloadInputViews()
    }
    
}
