import UIKit

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

//// 元の日付の文字列
//let dateString = "2015/03/04 12:34:56 +09:00"
//
//// Dateに変換
//let date = DateUtils.dateFromString(string: dateString, format: "yyyy/MM/dd HH:mm:ss Z")
//print(date)
//// => "2015-03-04 03:34:56 +0000\n"
//
//// Stringに再変換
//print(DateUtils.stringFromDate(date: date, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))
//// => "2015年03月04日 12時34分56秒 +0900\n"
