//
//  UpdateChecker.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import Foundation
import ZIPFoundation

class UpdateChecker: ObservableObject {
	@Published var updateAvailable = false
	@Published var latestVersion: String? = nil
	private let repoOwner = "klim4ik21"
	private let repoName = "Focus"
	private var downloadTask: URLSessionDownloadTask?

	func checkForUpdates() {
		guard let url = URL(string: "https://api.github.com/repos/\(repoOwner)/\(repoName)/releases/latest") else {
			print("Invalid URL")
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				print("Error fetching updates: \(error.localizedDescription)")
				return
			}
			
			guard let data = data else {
				print("No data received")
				return
			}
			
			do {
				if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				   let tagName = json["tag_name"] as? String,
				   let assets = json["assets"] as? [[String: Any]],
				   let asset = assets.first(where: { $0["name"] as? String == "Focus.zip" }), // Замените на имя вашего файла
				   let downloadUrl = asset["browser_download_url"] as? String {
					
					DispatchQueue.main.async {
						self.latestVersion = tagName
						self.compareVersions(latest: tagName, downloadUrl: downloadUrl)
					}
				}
			} catch {
				print("Error parsing JSON: \(error.localizedDescription)")
			}
		}
		
		task.resume()
	}
	
	private func compareVersions(latest: String, downloadUrl: String) {
		let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
		
		if latest != currentVersion {
			updateAvailable = true
			downloadAndInstallUpdate(from: downloadUrl)
		} else {
			updateAvailable = false
		}
	}
	
	private func downloadAndInstallUpdate(from url: String) {
		guard let downloadURL = URL(string: url) else {
			print("Invalid download URL")
			return
		}

		let fileManager = FileManager.default

		downloadTask = URLSession.shared.downloadTask(with: downloadURL) { tempLocalUrl, response, error in
			if let error = error {
				print("Error downloading update: \(error.localizedDescription)")
				return
			}

			guard let tempLocalUrl = tempLocalUrl else {
				print("No file downloaded")
				return
			}

			do {
				let appPath = URL(fileURLWithPath: Bundle.main.bundlePath)
				let destinationPath = appPath.deletingLastPathComponent().appendingPathComponent("Focus.zip")

				// Перемещаем загруженный файл
				try fileManager.moveItem(at: tempLocalUrl, to: destinationPath)

				// Распаковываем архив
				let unzipPath = appPath.deletingLastPathComponent()
				try fileManager.unzipItem(at: destinationPath, to: unzipPath)

				// Перезапуск приложения
				try self.restartApplication()
			} catch {
				print("Error installing update: \(error.localizedDescription)")
			}
		}

		downloadTask?.resume()
	}

	
	private func restartApplication() throws {
		let appPath = Bundle.main.bundlePath
		let task = Process()
		task.launchPath = "/usr/bin/open"
		task.arguments = [appPath]
		task.launch()
		exit(0)
	}
}
