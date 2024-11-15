//
//  FocusApp.swift
//  Focus
//
//  Created by Klim on 11/14/24.
//

import SwiftUI
import UserNotifications

@main
struct FocusApp: App {
	@StateObject private var timer = PomodoroTimer(workInMinutes: 1, breakInMinutes: 1)
	@StateObject private var updateChecker = UpdateChecker()
	@State private var isWorkMode: Bool = false

	var body: some Scene {
		MenuBarExtra {
			VStack {
				TimerDemo(timer: timer)
					.frame(minWidth: 300, minHeight: 300)
					.onAppear {
						isWorkMode = timer.mode == .work
						updateChecker.checkForUpdates()
					}

				if updateChecker.updateAvailable {
					Button("Update Available!") {
						updateChecker.checkForUpdates()
					}
					.padding()
					.foregroundColor(.red)
				}
			}
			.padding()
		} label: {
			HStack(spacing: 10) {
				Image(systemName: "timer")
				Text("\(timer.secondsLeftString) \(isWorkMode ? "💪" : "☕️")")
			}
		}
		.menuBarExtraStyle(.window)
	}
}
