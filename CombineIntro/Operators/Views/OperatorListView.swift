//
//  OperatorListView.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import SwiftUI

struct OperatorListView: View {
    
    @StateObject private var vm = OperatorViewModel()
    @State private var showOperatorView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(vm.operatorGroups) { group in
                        sectionView(group)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Operators")
            .background(
                NavigationLink(
                    destination: OperatorView()
                        .environmentObject(vm),
                    isActive: $showOperatorView,
                    label: {
                        EmptyView()
                    }
                )
            )
        }
    }
    
    private func operatorDidClick(item: OperatorModel) {
        vm.currentOperator = item
        showOperatorView.toggle()
    }
}

extension OperatorListView {
    private func sectionView(_ group: OperatorGroup) -> some View {
        Section {
            ForEach(group.operators) { item in
                HStack(spacing: 0) {
                    Text(item.operatorName)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.01))
                .onTapGesture {
                    operatorDidClick(item: item)
                }
            }
        } header: {
            Text(group.title)
                .font(.headline)
        }
    }
}

struct OperatorListView_Previews: PreviewProvider {
    static var previews: some View {
        OperatorListView()
    }
}
