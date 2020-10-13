import UIKit
import RealmSwift

class DetailDiaryViewController: UIViewController {
    @IBOutlet var titleView: UITextView!
    @IBOutlet var bodyView: UITextView!
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
        titleView.reloadInputViews()
        bodyView.reloadInputViews()
    }
    
    

}
