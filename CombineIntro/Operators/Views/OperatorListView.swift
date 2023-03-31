//
//  OperatorListView.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import SwiftUI

struct OperatorListView: View {
    
    @StateObject private var vm = OperatorsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(vm.operatorGroups) { group in
                        Section {
                            ForEach(group.operators) { item in
                                NavigationLink(destination: OperatorView()) {
                                    Text(item.operatorName)
                                }
                            }
                        } header: {
                            Text(group.title)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Operators")
        }
    }
}

struct OperatorListView_Previews: PreviewProvider {
    static var previews: some View {
        OperatorListView()
    }
}
