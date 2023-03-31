//
//  OperatorView.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import SwiftUI
import Combine

struct OperatorView: View {
    
    @EnvironmentObject private var vm: OperatorsViewModel
    
    init() {
        print("init")
    }
    
    var body: some View {
        operatorView(OperatorModel.switchToLatest)
    }

    @ViewBuilder
    func operatorView(_ viewModel: OperatorModel) -> some View {
        VStack() {
            valuesRow(viewModel.p1)
            if let p2 = viewModel.p2 {
                valuesRow(p2)
            }
            operatorRow(text: viewModel.operatorTitle)
            valuesRow(viewModel.output)
        }
    }

    func valuesRow(_ values: [String]) -> some View {
        return ZStack {
            ArrowView()
            HStack(spacing: 20) {
                ForEach(values, id: \.self) {
                    circle(withValue: $0)
                }
            }
        }
    }

    func operatorRow(text: String) -> some View {
        return ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .strokeBorder(lineWidth: 2)
                .frame(width: 300, height: 80)
            Text(text)
                .font(.custom("Menlo", size: 30))
                .fontWeight(.bold)
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }

    func circle(withValue value: String) -> some View {
        let style = ValueStyle.style(for: value)

        return ZStack {
            Circle()
                .stroke(style.borderColor, lineWidth: 2)
                .background(Circle().fill(style.fillColor))
                .frame(width: 80, height: 80)
            Text(value)
                .foregroundColor(style.textColor)
                .font(ValueStyle.font(for: value))
        }
    }
}

struct OperatorView_Previews: PreviewProvider {
    static var previews: some View {
        OperatorView()
    }
}
