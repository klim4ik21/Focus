//
//  UpdateChecker.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import Foundation
import AppUpdater

class UpdateChecker: ObservableObject {
	private let updater = AppUpdater(owner: "klim4ik21", repo: "Focus")
	@Published var updateAvailable = false
	private var timer: Timer?

	init() {
		startCheckingForUpdates() // Запуск проверки обновлений при инициализации
	}

	// Метод для старта проверки обновлений каждую минуту
	private func startCheckingForUpdates() {
		timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(checkForUpdates), userInfo: nil, repeats: true)
	}

	// Метод для проверки обновлений
	@objc func checkForUpdates() {
		updater.check().done { update in
			// Здесь проверяется наличие обновлений
			self.updateAvailable = true
		}.catch { error in
			print("Error checking for updates: \(error.localizedDescription)")
			self.updateAvailable = false
		}
	}

	// Метод для загрузки обновлений
	func downloadUpdate() {
		// Добавьте логику для скачивания обновлений, если они доступны
	}

	deinit {
		timer?.invalidate() // Очистка таймера при удалении объекта
	}
}
