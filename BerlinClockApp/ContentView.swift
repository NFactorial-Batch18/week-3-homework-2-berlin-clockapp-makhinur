//
//  ContentView.swift
//  BerlinClockApp
//
//  Created by Makhinur Talgatova on 11.05.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date()
    @State var currentTime = Time(hour: 21, min: 58, sec: 21)
    var receiver = Timer.publish(every: 1, on: .current , in: .default)
        .autoconnect()
    
    var body: some View {
        return ZStack {
            Color.gray.opacity(0.2).ignoresSafeArea()
            VStack {
                header
                BerlinClock(currentTime: $currentTime)
                    .onAppear(perform: { getTimeComponents() })
                    .onReceive(receiver) { _ in getTimeComponents()  }
                footer
                Spacer()
            }
        }
        
    }
    
    var header: some View {
        Text("Time is \(getTime())")
            .font(.system(size: 17).bold())
    }
    
    
    var footer: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 358, height: 54, alignment: .center)
            datePicker
                .environment(\.locale, Locale(identifier: "ru_KZ"))
        }
    }
    
    var datePicker: some View {
        HStack {
            DatePicker(selection: $selectedDate, displayedComponents: .hourAndMinute) {
                Text("Insert time")
            }
            .datePickerStyle(.compact)
            .padding(50)
        }
    }
    
    private func getTime() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        return format.string(from: selectedDate)
    }
    
    private func getTimeComponents() {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: selectedDate)
        let min = calendar.component(.minute, from: selectedDate)
        let sec = calendar.component(.second, from: Date())
        currentTime = Time(hour: hour, min: min, sec: sec)
    }
}

struct BerlinClock: View {
    @Binding var currentTime: Time
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(width: 358, height: 312, alignment: .center)
            VStack(spacing: 20) {
                CustomCircle(isActive: currentTime.sec%2 != 0 ? true : false)
                HStack {
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 5 ? true : false)
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 10 ? true : false)
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 15 ? true : false)
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 20 ? true : false)
                }
                HStack {
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 21 ? true : false)
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 22 ? true : false)
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour >= 23 ? true : false)
                    CustomRectangle(color: Color.red, width: 74, isActive: currentTime.hour == 24 ? true : false)
                }
                HStack(spacing: 9) {
                    Group {
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 5 ? true : false)
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 10 ? true : false)
                        CustomRectangle(color: Color.red, width: 21, isActive: currentTime.min >= 15 ? true : false)
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 20 ? true : false)
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 25 ? true : false)
                        CustomRectangle(color: Color.red, width: 21, isActive: currentTime.min >= 30 ? true : false)
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 35 ? true : false)
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 40 ? true : false)
                        CustomRectangle(color: Color.red, width: 21, isActive: currentTime.min >= 45 ? true : false)
                        CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 50 ? true : false)
                    }
                    CustomRectangle(color: Color.yellow, width: 21, isActive: currentTime.min >= 55 ? true : false)
                }
                HStack {
                    CustomRectangle(color: Color.yellow, width: 74, isActive: currentTime.min >= 56 ? true : false)
                    CustomRectangle(color: Color.yellow, width: 74, isActive: currentTime.min >= 57 ? true : false)
                    CustomRectangle(color: Color.yellow, width: 74, isActive: currentTime.min >= 58 ? true : false)
                    CustomRectangle(color: Color.yellow, width: 74, isActive: currentTime.min == 59 ? true : false)
                }
            }
        }
    }
    
}

struct CustomRectangle: View {
    let color: Color
    let width: CGFloat
    let isActive: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color.opacity(isActive ? 1 : 0.5))
            .frame(width: width, height: 32, alignment: .center)
    }
}

struct CustomCircle: View {
    let isActive: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.yellow.opacity(isActive ? 1: 0.5))
                .frame(width: 56, height: 56, alignment: .center)
        }
    }
}

struct Time {
    var hour: Int
    var min: Int
    var sec: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
