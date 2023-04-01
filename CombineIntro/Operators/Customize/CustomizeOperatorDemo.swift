//
//  CustomizeOperatorDemo.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-01.
//

import SwiftUI

struct CustomizeOperatorDemo: View {
    
    @StateObject private var vm = CustomizeOperatorViewModel()
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct CustomizeOperatorDemo_Previews: PreviewProvider {
    static var previews: some View {
        CustomizeOperatorDemo()
    }
}
