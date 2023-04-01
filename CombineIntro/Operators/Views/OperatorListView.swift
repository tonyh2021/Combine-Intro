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
            if #available(iOS 14.0, *) {
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
            } else {
                // Fallback on earlier versions
                tipViewForIOS13
            }
        }
    }
    
    private func operatorDidClick(item: OperatorModel) {
        vm.currentOperator = item
        showOperatorView.toggle()
    }
}

extension OperatorListView {
    
    private var tipViewForIOS13: some View {
        VStack(spacing: 20) {
            Text("OperatorDemo only supports iOS14+ 😂")
            .font(.title)
            Text("For for demos, please review UIKit or ")
            Button(action: {
                if let url = URL(string: "https://github.com/tonyh2021/SwiftfulCrypto") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("SwiftfulCrypto")
            }
        }
    }
    
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
        NavigationView {
            OperatorListView()
        }
        .navigationViewStyle(.stack)
    }
}
