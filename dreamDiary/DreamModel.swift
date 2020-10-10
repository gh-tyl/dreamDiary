import UIKit
import FSCalendar
import RealmSwift

class DreamsModel: Object {
    @objc dynamic var title = ""
    @objc dynamic var body = ""
    @objc dynamic var date = ""
}

//// イベント作成
//func recordDream(success: @escaping () -> Void) {
//    do {
//        let realm = try Realm()
//        let dreamModel = DreamModel()
//        dreamModel.title = titleTextField.text ?? ""
//        dreamModel.body = bodyTextView.text
//        dreamModel.date = stringFromDate(date: date as Date, format: "yyyy.MM.dd")
//        
//        try realm.write {
//            realm.add(dreamModel)
//            success()
//        }
//    } catch {
//        print("recording error")
//    }
//}
//
//// カレンダーの日付にイベントを表示
//func getModel() {
//    let results = realm.objects(DreamModel.self)
//    var dreamModels: [[String:String]] = []
//    for result in results {
//        dreamModels.append(["title":result.title,
//                            "body":result.body,
//                            "date":result.date])
//    }
//}
//
////選択された日付のみの選出
//func filterModel() {
//    var filteredDreams: [[String:String]] = []
//    for dreamModel in dreamModels {
//        if dreamModel['date'] == stringFromDate(date: selectedDate as Date, format: "yyyy.MM.dd") {
//            filterDreams.append(dreamModel)
//        }
//    }
//    filterModels = filteredDreams
//}
//
//// 表示の切り替え
//func calendar(_ calendar FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//    filterModel()
//    tableView.reloadData()
//}
//
//// イベントの削除
//// スワイプでセル削除
//
//// データ削除
//func deleteModel(selectedData: String, indexPath: IndexPath) {
//    let results = realm.objects(DreamModel.self).filter("date == '\(selectedDate)'")
//    do {
//        try realm.write {
//            realm.delete(results[indexPath.row])
//            getModel()
//        }
//    } catch {
//        print("deleting error")
//    }
//}
//
//// イベントがある日にマルポチ
//func calendar(_ calendar: FSCalendar, numberOfDreamsFor date: Date) -> Int {
//    let date = stringFromDate(date: date, format: "yyyy.MM.dd")
//    var hasDream: Bool = false
//    for dreamModel in DreamModels {
//        if dreamModel["date"] == date {
//            hasDream = true
//        }
//    }
//    if hasDream {
//        return 1
//    } else {
//        return 0
//    }
//}
