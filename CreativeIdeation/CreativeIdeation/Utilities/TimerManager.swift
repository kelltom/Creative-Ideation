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

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeRemaining -= 1
        }
    }

    func pause() {
        timer.invalidate()
    }

    func reset() {
        timer.invalidate()
        timeRemaining = 600
    }

    func toString() -> String {
        let minutes: Int = timeRemaining / 60
        var seconds: String = ""
        if timeRemaining % 60 < 10 {
            seconds += "0"
        }
        seconds += String(timeRemaining % 60)
        return String(format: "%d:" + seconds, minutes)
    }
}
