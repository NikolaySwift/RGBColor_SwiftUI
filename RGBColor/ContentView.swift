//
//  ContentView.swift
//  RGBColor
//
//  Created by NikolayD on 11.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var redSliderValue = Double.random(in: 0...255)
    @State private var greenSliderValue = Double.random(in: 0...255)
    @State private var blueSliderValue = Double.random(in: 0...255)
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            ColorizedView(
                color: Color(
                    red: redSliderValue / 255,
                    green: greenSliderValue / 255,
                    blue: blueSliderValue / 255
                )
            )
            
            VStack {
                setupColorView(sliderValue: $redSliderValue, color: .red)
                setupColorView(sliderValue: $greenSliderValue, color: .green)
                setupColorView(sliderValue: $blueSliderValue, color: .blue)
            }
            .focused($isFocused)
            .keyboardType(.numberPad)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
            
            
            Spacer()
        }
        .padding(24)
        .background(.tint.opacity(0.3))
        .onTapGesture {
            isFocused = false
        }
    }
}

#Preview {
    ContentView()
}

struct setupColorView: View {
    @Binding var sliderValue: Double
    
    @State private var textfieldValue = ""
    @State private var isPresented = false
    
    let color: Color
    
    private var sliderTextValue: String {
        lround(sliderValue).formatted()
    }
    
    var body: some View {
        HStack( spacing: 10) {
            Text(sliderTextValue)
                .frame(width: 40)
                .foregroundStyle(color)
                .font(.title2)
            
            Slider(value: $sliderValue, in: 0...255, step: 1)
                .tint(color)
                .onChange(of: sliderValue, setTextFieldValue)
                .animation(.default, value: sliderValue)
            
            TextField("", text: $textfieldValue, onEditingChanged: checkInputValue)
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(color)
                .frame(width: 70)
                .font(.title2)
                .multilineTextAlignment(.trailing)
                .alert(
                    "Wrong Number",
                    isPresented: $isPresented,
                    actions: { Button("OK", action: setTextFieldValue) }
                ) {
                    Text("Enter number from 0 to 255")
                }
        }
        .onAppear(perform: setTextFieldValue)
    }
    
    private func setTextFieldValue() {
        textfieldValue = sliderTextValue
    }
    
    private func checkInputValue(_ editStatus: Bool) {
        if !editStatus {
            guard let value = Double(textfieldValue),
                  (0...255).contains(value) else {
                isPresented = true
                return
            }
            sliderValue = value
        }
    }
}

struct ColorizedView: View {
    
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .foregroundStyle(color)
            .frame(height: 200)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.white, lineWidth: 4))
            .shadow(color: .gray, radius: 10, x: 10, y: 10)
    }
}
