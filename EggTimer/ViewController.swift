//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var titleView1: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var player: AVAudioPlayer? = nil;
    
    let eggTimes: [String:Int] = [
        "Soft": 5,
        "Medium": 420,
        "Hard": 720
    ];
    
    var timer: Timer? = nil;
    var secondsLast = 0;
    
    let url: URL? = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
    
    override func viewDidLoad() {
        do {
            player = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)
        } catch {
            print("Error:viewDidLoad");
        }
    }
    
    @IBAction func onEggButtonTouch(_ sender: UIButton) {
        progressView.progress = 0.0;
        timer?.invalidate();
        
        let hardness = sender.currentTitle!;
        
        secondsLast = 0;
        
        titleView1.text = "Preparing!";

        // Это же можно сделать и через метод с #selector
        // и отдельной функцией
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (t) in
            let total = self.eggTimes[hardness]!;
            
            self.secondsLast += 1;
            self.progressView.progress = Float(self.secondsLast) / Float(total);
            
            print("\(total - self.secondsLast) seconds last.");
            
            if (self.secondsLast >= total) {
                t.invalidate();
                self.titleView1.text = "Done!";
                self.playAlarm();
            }
        })
        
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func playAlarm () {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default);
            
            try AVAudioSession.sharedInstance().setActive(true);
        } catch {
            print("error");
        }
        
        player?.play()
    }
}
