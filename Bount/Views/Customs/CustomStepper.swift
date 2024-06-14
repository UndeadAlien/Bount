//
//  CustomStepper.swift
//  Bount
//
//  Created by Connor Hutchinson on 6/14/24.
//

import SwiftUI

struct CustomStepper: View {
    
    @Binding var value: Int
    
    var range: ClosedRange<Int> = 0...Int.max
    
    var body: some View {
        HStack {
            Button(action: decrement) {
                Image(systemName: "minus.circle.fill")
                    .font(.title)
            }
            .disabled(value == range.lowerBound)

            Text("\(value)")
                .modifier(FontMod(size: 14, isBold: true))
                .frame(minWidth: 40, alignment: .center)

            Button(action: increment) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
            }
            .disabled(value == range.upperBound)
        }
    }
    
    private func decrement() {
        if value > range.lowerBound {
            value -= 1
            print("Decremented: \(value)")
        }
    }

    private func increment() {
        if value < range.upperBound {
            value += 1
            print("Incremented: \(value)")
        }
    }

}

#Preview {
    @State var val = 10
    return CustomStepper(value: $val)
}
