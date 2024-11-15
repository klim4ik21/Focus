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
				return "bell-focus.aiff"
			case .tick:
				return "tick.wav"
		}
	}
}

class PomodoroAudio {
	private var audioPlayer: AVAudioPlayer?
	
	func play(_ sound: PomodoroAudioSounds) {
		let path = Bundle.main.path(forResource: sound.resource, ofType: nil)!
		let url = URL(filePath: path)
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
			audioPlayer?.play()
		} catch {
			print(error.localizedDescription)
		}
	}
}
