import UIKit
import Foundation
import AudioToolbox
import AVFoundation
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate {
    var window: UIWindow?
    var sound: NSURL!
    var audioPlayer: AVAudioPlayer?
    var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 通知許可の取得
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
        }
        // AVAudioSessionCategory設定
        var error: NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch let error1 as NSError{
            error = error1
            print("could not set session. err:\(error!.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error1 as NSError{
            error = error1
            print("could not active session. err:\(error!.localizedDescription)")
        }
        window?.tintColor = UIColor.red
        
        /// AVAudioSessionCategory設定
        let session = AVAudioSession.sharedInstance()
        do {
            // CategoryをPlaybackにする
            try session.setCategory(.playback, mode: .default)
        } catch  {
        }
        // session有効化
        do {
            try session.setActive(true)
        } catch {
        }
        return true
    }
    
    //snooze notification handler when app in background
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    //    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
    //    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("application")
//        playSound()
        playAlarm()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let timer = Timer(fireAt: NSDate(timeIntervalSinceNow: 20) as Date, interval: 60.0, target: self, selector: Selector(("playAlarm")), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        //バックグラウンドで行いたい処理があるとき
        backgroundTaskID = application.beginBackgroundTask {
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
        print("applicationWillResignActive")
        playSound()
        playAlarm()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (notifications: [UNNotification]) in
            for notification in notifications {
                AlarmVC.shared.getAlarm(from: notification.request.identifier)
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.endBackgroundTask(self.backgroundTaskID)
    }
    
    //AlarmApplicationDelegate protocol
    func playSound() {
        print("playsound")
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
                                              nil,
                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                              },
                                              nil)
        let soundIdRing:SystemSoundID = 1005  // alarm.caf
        AudioServicesPlaySystemSound(soundIdRing)
    }
    
    func playAlarm() {
        print("playalarm")
//        //音源のパス
//        let soundFilePath = Bundle.main.path(forResource: "bell", ofType: "mp3")!
//        print(soundFilePath)
//
////        //self.sound = NSURL(fileURLWithPath: Bundle.mainBundle.pathForResource("bell", ofType: "mp3")!)
////        self.sound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bell", ofType: "mp3")!)
////        try! self.audioPlayer = AVAudioPlayer(contentsOf: sound as URL, fileTypeHint: nil)
////        audioPlayer!.play()
//
//        //パスのURL
////        let sound:URL = URL(fileURLWithPath: soundFilePath)
//        //AVAudioPlayerを作成
////        audioPlayer = try! AVAudioPlayer(contentsOf: sound, fileTypeHint:nil)
//        // バックグラウンドでもオーディオ再生可能にする
//        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
//        try! AVAudioSession.sharedInstance().setActive(true)
////        audioPlayer!.play()
//        let soundIdRing:SystemSoundID = 1005  // alarm.caf
//        AudioServicesPlaySystemSound(soundIdRing)
        let soundName: String = "bell"
        
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
            nil,
            { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            },
            nil)
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
        print(url)
        var error: NSError?
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("audioPlayer error \(err.localizedDescription)")
            return
        } else {
            audioPlayer!.delegate = self
            audioPlayer!.prepareToPlay()
        }
        
        //negative number means loop infinity
        audioPlayer!.numberOfLoops = -1
        audioPlayer!.play()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // アプリ起動中でもアラートと音で通知
        completionHandler([.alert, .sound])
        let uuid = notification.request.identifier
        AlarmVC.shared.getAlarm(from: uuid)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        print("userNotificationCenter")
//        playSound()
        playAlarm()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        if identifier == "snooze"{
            let snoozeAction = UNNotificationAction(
                identifier: "snooze",
                title: "Snooze 5 Minutes",
                options: []
            )
            let noAction = UNNotificationAction(
                identifier: "stop",
                title: "stop",
                options: []
            )
            let alarmCategory = UNNotificationCategory(
                identifier: "alarmCategory",
                actions: [snoozeAction, noAction],
                intentIdentifiers: [],
                options: [])
            UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
            let content = UNMutableNotificationContent()
            content.title = "Snooze"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "alarmCategory"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
            let request = UNNotificationRequest(identifier: "Snooze", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        let uuid = response.notification.request.identifier
        AlarmVC.shared.getAlarm(from: uuid)
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        completionHandler()
    }
}

//import UIKit
//import Foundation
//import AudioToolbox
//import AVFoundation
//import UserNotifications
//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate{
//    var window: UIWindow?
//    var audioPlayer: AVAudioPlayer?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        var error: NSError?
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//        } catch let error1 as NSError{
//            error = error1
//            print("could not set session. err:\(error!.localizedDescription)")
//        }
//        do {
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch let error1 as NSError{
//            error = error1
//            print("could not active session. err:\(error!.localizedDescription)")
//        }
//        window?.tintColor = UIColor.red
//
//        return true
//    }
//
//    //receive local notification when app in foreground
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//
//        //show an alert window
//        let storageController = UIAlertController(title: "Alarm", message: nil, preferredStyle: .alert)
//        var isSnooze: Bool = false
//        var soundName: String = ""
//        var index: Int = -1
//        if let userInfo = notification.userInfo {
//            isSnooze = userInfo["snooze"] as! Bool
//            soundName = userInfo["soundName"] as! String
//            index = userInfo["index"] as! Int
//        }
//
//        playSound(soundName)
//        //schedule notification for snooze
//        if isSnooze {
//            let snoozeAction = UNNotificationAction(
//                identifier: "snooze",
//                title: "Snooze 5 Minutes",
//                options: []
//            )
//            let noAction = UNNotificationAction(
//                identifier: "stop",
//                title: "stop",
//                options: []
//            )
//            let alarmCategory = UNNotificationCategory(
//                identifier: "alarmCategory",
//                actions: [snoozeAction, noAction],
//                intentIdentifiers: [],
//                options: [])
//            UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
//            let content = UNMutableNotificationContent()
//            content.title = "Snooze"
//            content.sound = UNNotificationSound.default
//            content.categoryIdentifier = "alarmCategory"
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
//            let request = UNNotificationRequest(identifier: "Snooze", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { (error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//
//        let stopOption = UIAlertAction(title: "OK", style: .default) {
//            (action:UIAlertAction)->Void in self.audioPlayer?.stop()
//            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
//            //change UI
//            var mainVC = self.window?.rootViewController as? AlarmVC
//            if mainVC == nil {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                mainVC = storyboard.instantiateViewController(withIdentifier: "Alarm") as? AlarmVC
//            }
//        }
//
//        storageController.addAction(stopOption)
//        window?.rootViewController?.navigationController?.present(storageController, animated: true, completion: nil)
//    }
//
//    //snooze notification handler when app in background
//    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
//        var index: Int = -1
//        var soundName: String = ""
//        if let userInfo = notification.userInfo {
//            soundName = userInfo["soundName"] as! String
//            index = userInfo["index"] as! Int
//        }
//        completionHandler()
//    }
//
//    //print out all registed NSNotification for debug
//    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
//
//        print(notificationSettings.types.rawValue)
//    }
//
//    //AlarmApplicationDelegate protocol
//    func playSound(_ soundName: String) {
//        //vibrate phone first
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//        //set vibrate callback
//        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
//                                              nil,
//                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
//                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
//                                              },
//                                              nil)
//
//        let url = URL(fileURLWithPath: Bundle.main.path(forResource: soundName, ofType: "mp3")!)
//        var error: NSError?
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//        } catch let error1 as NSError {
//            error = error1
//            audioPlayer = nil
//        }
//
//        if let err = error {
//            print("audioPlayer error \(err.localizedDescription)")
//            return
//        } else {
//            audioPlayer!.delegate = self
//            audioPlayer!.prepareToPlay()
//        }
//
//        //negative number means loop infinity
//        audioPlayer!.numberOfLoops = -1
//        audioPlayer!.play()
//    }
//
//    //AVAudioPlayerDelegate protocol
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//    }
//
//    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
//    }
//
//    //UIApplicationDelegate protocol
//    func applicationWillResignActive(_ application: UIApplication) {
//        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        //audioPlayer?.pause()
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        //audioPlayer?.play()
//        //alarmScheduler.checkNotification()
//    }
//
//    func applicationWillTerminate(_ application: UIApplication) {
//        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//    }
//}
