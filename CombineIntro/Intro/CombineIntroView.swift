//
//  CombineIntroView.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-10.
//

import SwiftUI

struct CombineIntroView: View {
    
    private var testCase: CombineTestable

    init() {
        self.testCase = CustomCombine()
    }
    
    var body: some View {
        ZStack {
            Button {
                testCase.run()
            } label: {
                Text("Tap me...")
            }
        }
    }
}

struct CombineIntroView_Previews: PreviewProvider {
    static var previews: some View {
        CombineIntroView()
    }
}
