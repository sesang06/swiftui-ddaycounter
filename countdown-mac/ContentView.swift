//
//  ContentView.swift
//  countdown-mac
//
//  Created by D-day on 2020/08/03.
//  Copyright © 2020 D-day. All rights reserved.
//

import SwiftUI


class Clock: ObservableObject {

  @Published var date: Date = Date()

  @Published var endDate: Date = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: "2020-09-02")!
  }()

  @Published
  var dDay: Int = 0
  @Published
  var left: String = ""

  var timer: Timer?

  func onAppear() {
    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(onFire), userInfo: nil, repeats: true)
  }

  @objc func onFire() {
    self.date = Date()
    self.calDDay()
    self.calInterval()
  }

  func calDDay() {
    let cal = Calendar.current
    let com = cal.dateComponents([.day], from: date, to: endDate)
    self.dDay = com.day ?? 0

  }

  func calInterval() {
    let interval = endDate.timeIntervalSince(date)
    let seconds =  Double(Int(interval.truncatingRemainder(dividingBy: 60) * 10)) / 10
    let minutes = Int(interval) / 60 % 60
    let hour = Int(interval) / 60 / 60 % 24
    let day = Int(interval) / 60 / 60 / 24
    let format = "\(day)일 \(hour)시간 \(minutes)분 \(seconds)초"
    self.left = format
  }

}

struct ContentView: View {

  @ObservedObject var clock = Clock()

  var body: some View {
    GeometryReader { geometry in
      VStack {
        Text("D-\(self.clock.dDay)")
          .font(Font.largeTitle)
          .frame(width: geometry.size.width, height: nil)
          .padding([.bottom], 10)

        Text("2020/9/2")
          .font(Font.headline)
          .frame(width: geometry.size.width, height: nil)
          .padding([.bottom], 5)

        Text("\(self.clock.left)")
          .font(Font.subheadline)
          .frame(width: geometry.size.width, height: nil)
      }
      .frame(width: geometry.size.width, height: nil)
      .onAppear(perform: self.clock.onAppear)
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
