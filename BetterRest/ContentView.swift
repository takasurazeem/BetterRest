//
//  ContentView.swift
//  BetterRest
//
//  Created by Takasur Azeem on 23/02/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        Form {
            Section {
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            }
            Section {
                DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
                    .labelsHidden()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
