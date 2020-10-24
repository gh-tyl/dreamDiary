import UIKit

protocol AlarmTimeCellDelegate {
    func alarmTimeCell(switchTappe:UITableViewCell,isOn:Bool)
}
class AlarmTimeCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var sw: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryView = sw
    }
}
