//
//  Timer.swift
//  PomoTests
//
//  Created by Shai Mishali on 18/04/2023.
//

import Foundation

struct TimerItem: Codable {
    let id: UUID
    let title: String
    let secondsElapsed: Int
    let date: Date
}
