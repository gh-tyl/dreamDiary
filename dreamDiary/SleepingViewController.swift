import UIKit

class SleepingViewController: UIViewController {
    
    //インスタンスを生成
    var currentTime = CurrentTime()
    
    @IBOutlet var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        //前のViewControllerに戻る
        dismiss(animated: true, completion: nil)
    }
    
    func updateTime(_ time:String) {
        timeLabel.text = time
    }
    
}
