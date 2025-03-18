//
//  ErrorView.swift
//  RecipeList
//
//  Created by Evan Templeton on 3/18/25.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "line.diagonal")
                    .font(.system(size: 120))
                Image(systemName: "fork.knife")
                    .font(.system(size: 90))
                    .opacity(0.8)
            }
            .foregroundStyle(.gray)
            Text("Your server's on break.")
                .font(.largeTitle)
                .bold()
            Text("He'll be back in a minute. Sorry for the delay.")
                .font(.body)
                .foregroundStyle(.gray)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    ErrorView()
}
