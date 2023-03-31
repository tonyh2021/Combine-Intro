//
//  OperatorDiagram.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import SwiftUI

struct OperatorDiagram: View {
    let operatorModel: OperatorModel
    
    @State private var circleHeight: CGFloat
    
    private let circleSpacing: CGFloat
    
    init(operatorModel: OperatorModel) {
        self.operatorModel = operatorModel
        let screenWidth = UIScreen.main.bounds.width
        self.circleSpacing = screenWidth > 400 ? 20 : 16
        self.circleHeight = 80
    }
    
    var body: some View {
        operatorView
    }
}

extension OperatorDiagram {
    
    private var operatorView: some View {
        VStack() {
            valuesRow(operatorModel.p1)
            if let p2 = operatorModel.p2 {
                valuesRow(p2)
            }
            operatorRow
            valuesRow(operatorModel.output)
        }
        .frame(maxWidth: 500)
        .padding(.horizontal)
    }
    
    private func valuesRow(_ values: [String]) -> some View {
        GeometryReader { geometry in
            let count: CGFloat = CGFloat(operatorModel.output.count)
            let circleHeight = (geometry.size.width - (count + 1) * self.circleSpacing) / count
            ZStack() {
                ArrowView()
                HStack(spacing: circleSpacing) {
                    ForEach(values, id: \.self) {
                        circle(withValue: $0)
                    }
                }
            }
            .onAppear {
                self.circleHeight = circleHeight
            }
        }
        .frame(height: self.circleHeight)
        .allowsHitTesting(false)
    }

    private var operatorRow: some View {
        Text(operatorModel.operatorTitle)
            .font(.custom("Menlo", size: 26))
            .fontWeight(.bold)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(lineWidth: 2)
            )
        .padding(.vertical, 20)
    }

    private func circle(withValue value: String) -> some View {
        let style = ValueStyle.style(for: value)
        return ZStack {
            Circle()
                .stroke(style.borderColor, lineWidth: 2)
                .background(Circle().fill(style.fillColor))
                .frame(width: circleHeight, height: circleHeight)
            Text(value)
                .foregroundColor(style.textColor)
                .font(ValueStyle.font(for: value))
        }
    }
}

struct OperatorDiagram_Previews: PreviewProvider {
    static var previews: some View {
        OperatorDiagram(operatorModel: OperatorModel.map)
    }
}
