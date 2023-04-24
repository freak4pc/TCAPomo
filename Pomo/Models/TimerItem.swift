//
//  Timer.swift
//  PomoTests
//
//  Created by Shai Mishali on 18/04/2023.
//

import Foundation

struct TimerItem: Codable, Equatable, Identifiable {
    let id: UUID
    let title: String
    let secondsElapsed: Int
    let date: Date
}

func secondsToMinutes(_ seconds: Int) -> (minutes: String, seconds: String) {
    let mins = seconds / 60
    let secs = seconds % 60

    let minPart = mins < 10 ? "0\(mins)" : "\(mins)"
    let secPart = secs < 10 ? "0\(secs)" : "\(secs)"

    return (minPart, secPart)
}
