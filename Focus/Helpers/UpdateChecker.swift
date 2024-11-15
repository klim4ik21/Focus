//
//  UpdateChecker.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import Foundation
import SwiftUI

class UpdateChecker: ObservableObject {
	@Published var latestVersion: String? = nil
	@Published var updateAvailable: Bool = false
	private let appVersion = "1.0.0" // Текущая версия вашего приложения
	private let githubRepo = "username/repository" // Имя вашего репозитория на GitHub

	func checkForUpdates() {
		guard let url = URL(string: "https://api.github.com/repos/\(githubRepo)/releases/latest") else {
			print("Invalid GitHub URL")
			return
		}

		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data, error == nil else {
				print("Error fetching data: \(String(describing: error))")
				return
			}

			do {
				// Парсим JSON
				let releaseInfo = try JSONDecoder().decode(GitHubRelease.self, from: data)
				let latestVersion = releaseInfo.tagName
				self.latestVersion = latestVersion

				// Сравниваем версии
				if latestVersion != self.appVersion {
					DispatchQueue.main.async {
						self.updateAvailable = true
					}
				}
			} catch {
				print("Error decoding data: \(error)")
			}
		}
		task.resume()
	}

	func downloadUpdate() {
		guard let url = URL(string: "https://github.com/\(githubRepo)/releases/latest") else { return }
		NSWorkspace.shared.open(url) // Открывает страницу релиза на GitHub
	}
}

struct GitHubRelease: Codable {
	let tagName: String
}
