import UIKit
import FSCalendar
import RealmSwift

class DreamsModel: Object {
    // @objc dynamic var id: Int = 0
    @objc dynamic var id: String = NSUUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
