//
//  CustomizeOperatorDemo.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import SwiftUI

@available(iOS 14.0, *)
struct CustomizeOperatorDemo: View {
    
    @StateObject private var vm = CustomizeOperatorViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

@available(iOS 14.0, *)
struct CustomizeOperatorDemo_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeOperatorDemo()
    }
}
