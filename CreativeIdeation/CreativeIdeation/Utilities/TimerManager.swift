//
//  TimerManager.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-09-16.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var timeRemaining = 600
    var timer = Timer()
    var mode: StopWatchMode = .stopped

    enum StopWatchMode {
        case running
        case stopped
        case paused
    }

    func start() {
        timer.invalidate()
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
            if self.timeRemaining <= 0 {
                self.pause()
            }
        }
    }

    func pause() {
        timer.invalidate()
        mode = .paused
    }

    func reset() {
        timer.invalidate()
        timeRemaining = 600
        mode = .stopped
    }

    func toString() -> String {
        let minutes: Int = abs(timeRemaining / 60)
        var seconds: String = ""
        if abs(timeRemaining % 60) < 10 {
            seconds += "0"
        }
        seconds += String(abs(timeRemaining % 60))
        return String(format: "%d:" + seconds, minutes)
    }
}
