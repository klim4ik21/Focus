//
//  PomodoroNotification.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import Foundation
import UserNotifications

class PomodoroNotification {
	static func checkAuthorization(completion: @escaping (Bool) -> Void) {
		let notificationCenter = UNUserNotificationCenter.current()
		notificationCenter.getNotificationSettings { settings in
			switch settings.authorizationStatus {
				case .authorized:
					completion(true)
				case .notDetermined:
					notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, error in
						completion(allowed)
					}
				default:
					completion(false)
			}
		}
	}
	
	static func scheduleNotification(seconds: TimeInterval, title: String, body: String) {
		let notificationCenter = UNUserNotificationCenter.current()
		// Remove all notifications
		notificationCenter.removeAllDeliveredNotifications()
		notificationCenter.removeAllPendingNotificationRequests()
		// Set content notification
		let content = UNMutableNotificationContent()
		content.title = title
		content.body = body
		content.sound = .default
		content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: PomodoroAudioSounds.done.resource))
		// trigger
		let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
		// request
		let request = UNNotificationRequest(identifier: "my-notification", content: content, trigger: trigger)
		// add notification to center
		notificationCenter.add(request)
	}
}
