//
//  ViewForIOS13.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-06.
//

import SwiftUI

struct ViewForIOS13: View {
    var body: some View {
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
}

struct ViewForIOS13_Previews: PreviewProvider {
    static var previews: some View {
        ViewForIOS13()
    }
}
