//
//  AudioPlayerDemo.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import SwiftUI

struct AudioPlayerDemo: View {
	var audioPlayer = PomodoroAudio()
	
    var body: some View {
		VStack(spacing: 15) {
			Button("Play done") {
				audioPlayer.play(.done)
			}
			
			Button("Play tick") {
				audioPlayer.play(.tick)
			}
		}
    }
}

#Preview {
    AudioPlayerDemo()
}
