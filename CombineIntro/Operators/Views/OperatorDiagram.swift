//
//  OperatorDiagram.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import SwiftUI

struct OperatorDiagram: View {
    let operatorModel: OperatorModel
    
    private let circleSpacing: CGFloat
    @State private var circleHeight: CGFloat = 80
    
    init(operatorModel: OperatorModel) {
        self.operatorModel = operatorModel
        let screenWidth = UIScreen.main.bounds.width
        self.circleSpacing = screenWidth > 400 ? 20 : 16
    }
    
    var body: some View {
        operatorView
    }
}

extension OperatorDiagram {
    
    private var operatorView: some View {
        VStack(spacing: 0) {
            valuesRow(operatorModel.p1)
            if let p2 = operatorModel.p2 {
                valuesRow(p2)
            }
            operatorRow
            valuesRow(operatorModel.output)
        }
        .frame(maxWidth: 500, maxHeight: 300)
    }
    
//    https://stackoverflow.com/questions/61311007/dynamically-size-a-geometryreader-height-based-on-its-elements
    private func valuesRow(_ values: [String]) -> some View {
        VStack {
            GeometryReader { geometry in
                let count: CGFloat = CGFloat(operatorModel.output.count)
                let circleHeight = (geometry.size.width - (count + 1) * self.circleSpacing) / count
                ZStack() {
                    ArrowView()
                    HStack(spacing: circleSpacing) {
                        ForEach(values.indices, id: \.self) { index in
                            circle(withValue: values[index], circleHeight: circleHeight)
                        }
                    }
                }
                .background(GeometryReader {gp -> Color in
                    DispatchQueue.main.async {
                        // update on next cycle with calculated height of ZStack !!!
                        self.circleHeight = gp.size.height
                    }
                    return Color.clear
                })
            }
            .allowsHitTesting(false)
        }
        .frame(height: self.circleHeight)
    }

    private var operatorRow: some View {
        HStack {
            Text(operatorModel.operatorTitle)
                .font(.custom("Menlo", size: 30))
                .fontWeight(.bold)
            // fit the size
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 2)
                )
                .padding(.vertical, 20)
        }
        .padding(.horizontal, 20)
    }

    private func circle(withValue value: String, circleHeight: CGFloat) -> some View {
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
        OperatorDiagram(operatorModel: OperatorModel.filter)
    }
}
