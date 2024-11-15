//
//  Home.swift
//  Focus
//
//  Created by Klim on 11/14/24.
//

import SwiftUI

struct Home: View {
	var body: some View {
		ScrollView(.vertical) {
			VStack {
				Text("Focus app")
				
				Divider()
					.padding()
					.padding(.horizontal)
			}
			.padding()
		}
		.frame(minWidth: 300, idealWidth: 400, maxWidth: 500)
		.frame(minHeight: 300, idealHeight: 400, maxHeight: 500)
	}
}

#Preview {
	ContentView()
}
