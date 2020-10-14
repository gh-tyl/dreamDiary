//import UIKit
//
//class AlarmViewController: UIViewController {
//    let alarm = Alarm()
//    
//    @IBOutlet var sleepTimePicker: UIDatePicker!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //UIDatePickerを.timeモードにする
//        sleepTimePicker.datePickerMode = UIDatePicker.Mode.time
//        //現在の時間をDatePickerに表示
//        sleepTimePicker.setDate(Date(), animated: false)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        //AlarmでsleepTimerがnilじゃない場合
//        if alarm.sleepTimer != nil{
//            //再生されているタイマーを止める
//            alarm.stopTimer()
//        }
//    }
//    
//    @IBAction func alarmBtnWasPressed(_ sender: UIButton) {
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    @IBAction func alarmBtnWasPressed(_ sender: UIButton) {
//        //AlarmにあるselectedWakeUpTimeにユーザーの入力した日付を代入
//        alarm.selectedWakeUpTime = sleepTimePicker.date
//        //AlarmのrunTimerを呼ぶ
//        alarm.runTimer()
//        //SleepingViewControllerへの画面移動
//        performSegue(withIdentifier: "setToSleeping", sender: nil)
//    }
//    
//}
