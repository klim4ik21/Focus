//
//  FocusView.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import SwiftUI
import UserNotifications

struct FocusView: View {
	
	@State private var focusTime: Int = 20 * 60
	@State private var breakTime: Int = 10 * 60
	@State private var remainingTime: Int = 20 * 60
	@State private var isFocusMode: Bool = true
	@State private var timerActive: Bool = false
	@State private var selectedFocusMinutes: Int = 25
	@State private var selectedBreakMinutes: Int = 10
	@State private var totalCycles: Int = 4
	@State private var currentCycle: Int = 1
	private let timerInterval: TimeInterval = 1.0
	
	private func formattedTime() -> String {
		let minutes = remainingTime / 60
		let seconds = remainingTime % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
    var body: some View {
		VStack(spacing: 20) {
			Text("Cycle \(currentCycle)/\(totalCycles)")
				.font(.headline)
				.padding()
			
			Text(isFocusMode ? "Focus Time" : "Break Time")
				.font(.title)
				.padding()
			
			Text("\(formattedTime()) \(isFocusMode ? "💪" : "☕️")")
				.font(.largeTitle)
				.padding()
			
			HStack {
				Text("Total Cycles")
				Picker("", selection: $totalCycles) {
					ForEach(1...11, id: \.self) { cycle in
						Text("\(cycle)").tag(cycle)
					}
				}
				.pickerStyle(.menu)
			}
			
			HStack {
				Text("Focus Time:")
				Picker("", selection: $selectedFocusMinutes) {
					ForEach(1..<61, id: \.self) { minute in
						Text("\(minute) min").tag(minute)
					}
				}
				.pickerStyle(.menu)
				.onChange(of: selectedFocusMinutes) { newValue in
					focusTime = newValue * 60
					if isFocusMode {
						remainingTime = focusTime
					}
				}
			}
			
			HStack {
				Text("Break time:")
				Picker("", selection: $selectedBreakMinutes) {
					ForEach(1..<31, id: \.self) { minute in
						Text("\(minute) min").tag(minute)
					}
				}
				.pickerStyle(.menu)
				.onChange(of: selectedBreakMinutes) { newValue in
					breakTime = newValue * 60
					if !isFocusMode {
						remainingTime = breakTime
					}
				}
			}
			
			HStack {
				Button(timerActive ? "Pause" : "Start") {
					toggleTimer()
				}
				.buttonStyle(.borderedProminent)
				
				Button("Reset") {
					resetTimer()
				}
				.buttonStyle(.borderedProminent)
				.padding()
			}
			.padding()
		}
		.padding()
    }
	
	func toggleTimer() {
		timerActive.toggle()
		if timerActive {
			startTimer()
		}
	}
	
	func resetTimer() {
		timerActive = false
		currentCycle = 1
		remainingTime = isFocusMode ? focusTime : breakTime
	}
	
	func startTimer() {
			Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
				if remainingTime > 0 && timerActive {
					remainingTime -= 1
				} else {
					timer.invalidate()
					timerActive = false

					if remainingTime == 0 {
						isFocusMode.toggle()
						if isFocusMode {
							remainingTime = focusTime
						} else {
							remainingTime = breakTime
							// Increment current cycle after a break
							if !isFocusMode && currentCycle < totalCycles {
								currentCycle += 1
							}
						}

						// Notification
						let notificationMessage = isFocusMode ? "Time to focus! 💪" : "Time to take a break! ☕"
						sendNotification(title: "Pomodoro Timer", message: notificationMessage)

						// End session when all cycles are completed
						if currentCycle > totalCycles {
							sendNotification(title: "Pomodoro Timer", message: "Session complete! 🎉")
							resetTimer()
						} else {
							toggleTimer()
						}
					}
				}
			}
		}
	
	private func requestNotificationPermissions() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				print("Notification permissions error: \(error.localizedDescription)")
			}
		}
	}
	
	private func sendNotification(title: String, message: String) {
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = message
		
		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
		UNUserNotificationCenter.current().add(request) { error in
			if let error = error {
				print("Notification error: \(error.localizedDescription)")
			}
		}
	}
}

#Preview {
    FocusView()
}
