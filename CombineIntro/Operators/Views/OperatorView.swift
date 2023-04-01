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
            LazyVStack {
                descriptionView
                OperatorDiagram(operatorModel: vm.currentOperator)
                    .padding(.horizontal, 8)
            }
        }
        .navigationTitle(vm.currentOperator.operatorName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: link)
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
    
    @ViewBuilder
    private var link: some View {
        if let url = URL(string: vm.currentOperator.link) {
            Link("Document", destination: url)
        } else {
            EmptyView()
        }
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
