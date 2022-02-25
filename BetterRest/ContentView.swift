//
//  ContentView.swift
//  BetterRest
//
//  Created by Takasur Azeem on 23/02/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultWakeTime
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .onChange(of: wakeUp) { _ in
                            calculateBedtime()
                        }
                }
                Section {
                    Text("Desired Amount of Sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25) { change in
                        if change {
                            calculateBedtime()
                        }
                    }
                        
                }
                Section {
                    Text("Daily coffee intake")
                        .font(.headline)
//                    Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) {
                            Text($0 == 1 ? "1 cup" : "\($0) cups")
                        }
                    }
                }
                Section {
                    VStack {
                        Text(alertTitle)
                            .font(.title).bold()
                        Text(alertMessage)
                            .font(.largeTitle).bold()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("BetterRest")
            .onSubmit {
                calculateBedtime()
            }
            .onAppear(perform: calculateBedtime)
        }
        .navigationViewStyle(.stack)
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = Double((components.hour ?? 0) * 60 * 60)
            let minute = Double((components.minute ?? 0) * 60)
            
            let prediction = try model.prediction(wake: hour + minute, estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
