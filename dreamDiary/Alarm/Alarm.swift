import Foundation
import AVFoundation

class Alarm{
    var selectedWakeUpTime:Date?
    var audioPlayer: AVAudioPlayer!
    var sleepTimer: Timer?
    var seconds = 0
    
    //サウンド再生
    func soundAudio(){        
        //音源のパス
        //let soundFilePath = Bundle.main.path(forResource: "alarm", ofType: "caf")!
//        let soundFilePath = Bundle.main.path(forResource: "alarm", ofType: "caf")!
        let soundUrl = NSURL.fileURL(withPath: Bundle.main.path(forResource: "alarm", ofType:"caf")!)
        //パスのURL
//        let sound:URL = URL(fileURLWithPath: soundFilePath)
        do {
            //AVAudioPlayerを作成
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl, fileTypeHint:nil)
            // バックグラウンドでもオーディオ再生可能にする
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print("Could not load file")
        }
        //再生
        audioPlayer.play()
    }
    
    func stopTimer(){
        //タイマーを止める
        audioPlayer.stop()
    }
}
