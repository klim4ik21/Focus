//
//  PomodoroAudio.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import Foundation
import AVFoundation

enum PomodoroAudioSounds {
	case done
	case tick

	var resource: String {
		switch self {
		case .done:
			return "bell-focus"
		case .tick:
			return "tick"
		}
	}

	var fileExtension: String {
		switch self {
		case .done:
			return "aiff"
		case .tick:
			return "wav"
		}
	}
}

class PomodoroAudio {
	private var audioPlayer: AVAudioPlayer?

	func play(_ sound: PomodoroAudioSounds) {
		// Используем современное API для получения URL ресурса
		if let url = Bundle.main.url(forResource: sound.resource, withExtension: sound.fileExtension) {
			do {
				audioPlayer = try AVAudioPlayer(contentsOf: url)
				audioPlayer?.play()
			} catch {
				print("Error initializing audio player: \(error.localizedDescription)")
			}
		} else {
			print("Error: resource \(sound.resource).\(sound.fileExtension) not found.")
		}
	}
}
