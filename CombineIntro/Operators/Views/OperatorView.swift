//
//  OperatorView.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import SwiftUI
import Combine

struct OperatorView: View {
    
    @EnvironmentObject private var vm: OperatorViewModel
    
    var body: some View {
        ScrollView {
            Spacer(minLength: 1)
            LazyVStack {
                descriptionView
                OperatorDiagram(operatorModel: vm.currentOperator)
            }
        }
        .navigationTitle(vm.currentOperator.operatorName)
    }
}

extension OperatorView {
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(vm.currentOperator.operatorDescription)
                .font(.body)
                .foregroundColor(Color.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct OperatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OperatorView()
                .environmentObject(OperatorViewModel())
        }
    }
}
