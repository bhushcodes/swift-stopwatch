//twitter.com/bhushcodes

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    var startTime: DispatchTime?
    var isRunning = false
    var nanoSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        resetButton.isEnabled = false
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if !isRunning {
            startTime = DispatchTime.now()
            isRunning = true
            startButton.isEnabled = false
            stopButton.isEnabled = true
            resetButton.isEnabled = true
            updateTime()
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        if isRunning {
            isRunning = false
            startButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        isRunning = false
        timeLabel.text = "00:00:00.000"
        startButton.isEnabled = true
        stopButton.isEnabled = false
        resetButton.isEnabled = false
        nanoSeconds = 0
    }
    
    func updateTime() {
        guard let startTime = self.startTime else { return }
        let now = DispatchTime.now()
        let nanoTime = now.uptimeNanoseconds - startTime.uptimeNanoseconds + UInt64(nanoSeconds)
        
        let milliseconds = nanoTime / 1_000_000
        let millisecondsString = String(format: "%03d", milliseconds % 1_000)
        
        let seconds = milliseconds / 1_000
        let secondsString = String(format: "%02d", seconds % 60)
        
        let minutes = seconds / 60
        let minutesString = String(format: "%02d", minutes % 60)
        
        timeLabel.text = "\(minutesString):\(secondsString):\(millisecondsString)"
        
        if isRunning {
            nanoSeconds += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.updateTime()
            }
        }
    }
}
