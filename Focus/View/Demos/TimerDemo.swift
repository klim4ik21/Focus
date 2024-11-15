//
//  TimerDemo.swift
//  Focus
//
//  Created by Klim on 11/15/24.
//

import SwiftUI

struct TimerDemo: View {
	@ObservedObject var timer: PomodoroTimer
	@State private var workMinutes: String = "1" // минут работы (строка для ввода)
	@State private var breakMinutes: String = "1" // минут перерыва (строка для ввода)
	@State private var isEditingTime: Bool = true // флаг, чтобы управлять доступом к редактированию времени
	
	var body: some View {
		VStack {
			// Отображение оставшихся секунд
			Text("\(timer.secondsLeftString)")
			
			// Отображение в числовом формате
			Text("\(timer.secondsLeft)")
			
			// Режим (work / pause)
			Text("\(timer.mode.rawValue)")
			
			// Ввод времени работы и перерыва
			VStack(spacing: 20) {
				HStack {
					Text("Work Time: ")
					TextField("Minutes", text: $workMinutes)
						.frame(width: 60)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.onChange(of: workMinutes) { newValue in
							// Проверяем, что введены только цифры
							if let value = Double(newValue), value > 0 {
								timer._durationWork = value * 60
							} else {
								workMinutes = String(Int(timer._durationWork / 60)) // Восстанавливаем прежнее значение
							}
						}
						.disabled(!isEditingTime) // Блокируем редактирование во время работы
					
					Text("minutes")
				}
				
				HStack {
					Text("Break Time: ")
					TextField("Minutes", text: $breakMinutes)
						.frame(width: 60)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.onChange(of: breakMinutes) { newValue in
							// Проверяем, что введены только цифры
							if let value = Double(newValue), value > 0 {
								timer._durationBreak = value * 60
							} else {
								breakMinutes = String(Int(timer._durationBreak / 60)) // Восстанавливаем прежнее значение
							}
						}
						.disabled(!isEditingTime) // Блокируем редактирование во время работы
					
					Text("minutes")
				}
				
				// Кнопка для сохранения изменений времени
				if isEditingTime {
					Button("Update Time") {
						// Обновление времени таймера
						if let workTime = Double(workMinutes), let breakTime = Double(breakMinutes), workTime > 0, breakTime > 0 {
							timer._durationWork = workTime * 60
							timer._durationBreak = breakTime * 60
						}
					}
				}
			}
			
			// Кнопки управления таймером
			if timer.state == .idle {
				Button("Start") {
					timer.start()
					isEditingTime = false // Блокируем редактирование времени после начала
				}
			}
			
			if timer.state == .running {
				Button("Pause") {
					timer.pause()
					isEditingTime = true // Разрешаем редактирование времени при паузе
				}
			}
			
			if timer.state == .paused {
				Button("Resume") {
					timer.resume()
					isEditingTime = false // Блокируем редактирование времени после возобновления
				}
			}
		}
		.padding()
	}
}

#Preview {
	TimerDemo(timer: PomodoroTimer(workInMinutes: 1, breakInMinutes: 1))
}
