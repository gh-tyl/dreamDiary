import UIKit
import RealmSwift
import FSCalendar
import CalculateCalendarLogic

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var calendar: FSCalendar!
    // date4diary
    var dateValue: String!
    dynamic var presentDate = Date()
    // displayDate4test
    //@IBOutlet weak var labelDate: UILabel!
    // declare realm
    let realm = try! Realm()
    // TableView
    @IBOutlet weak var dreamTableView: UITableView!
    // Realm
    var dreamList: Results<DreamsModel>!
    var selectedDreamList: Results<DreamsModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.dreamTableView.dataSource = self
        self.dreamTableView.delegate = self
        
        // Realmからデータ取得
        do {
            let realm = try Realm()
            dreamList = realm.objects(DreamsModel.self)
        } catch {
        }
        selectedDreamList = dreamList.filter("%@ =< date AND date < %@", getBeginingAndEndOfDay(presentDate).begining as CVarArg, getBeginingAndEndOfDay(presentDate).end as CVarArg)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 再読み込み
        dreamTableView.reloadData()
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
//    fileprivate lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        // 祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        // 祝日判定を行う日にちの年,月,日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int) {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        return nil
    }
    
    // 日付毎のイベント表示
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // display on label
        let tmpDate = Calendar(identifier: .gregorian)
        let year4diary = tmpDate.component(.year, from: date)
        let month4diary = tmpDate.component(.month, from: date)
        let day4diary = tmpDate.component(.day, from: date)
        dateValue = "\(year4diary)/\(month4diary)/\(day4diary)"
        // datevalueの中でrealmの中身のフィルタリング
        selectedDreamList = dreamList.filter("%@ =< date AND date < %@", getBeginingAndEndOfDay(date).begining as CVarArg, getBeginingAndEndOfDay(date).end as CVarArg)
        dreamTableView.reloadData()
    }
    
    // 日の始まりと終わりを取得
    private func getBeginingAndEndOfDay(_ date:Date) -> (begining: Date , end: Date) {
        let begining = Calendar(identifier: .gregorian).startOfDay(for: date)
        let end = begining + 24*60*60
        return (begining, end)
    }
    
    // 記述した日付にマーク
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
        var tableList: Results<DreamsModel>!
        // 対象の日付が設定されているデータを取得
        do {
            let realm = try Realm()
            let predicate = NSPredicate(format: "%@ =< date AND date < %@", getBeginingAndEndOfDay(date).begining as CVarArg, getBeginingAndEndOfDay(date).end as CVarArg)
            tableList = realm.objects(DreamsModel.self).filter(predicate)
        } catch {
        }
        return tableList.count
    }
    
    // Table設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDreamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath)
        cell.textLabel!.text = selectedDreamList[indexPath.row].title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            if let indexPath = dreamTableView.indexPathForSelectedRow {
                guard let destination = segue.destination as? DetailDiaryViewController else {
                    fatalError("Failed to prepare DetailDiaryViewController.")
                }
                destination.dailyDream = selectedDreamList[indexPath.row]
            }
        }
    }
}
