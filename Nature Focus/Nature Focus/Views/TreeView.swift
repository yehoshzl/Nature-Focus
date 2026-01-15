//
//  TreeView.swift
//  Nature Focus
//
//  Created by Yosh on 14/01/2026.
//

import SwiftUI

struct TreeView: View {
    let progress: Double // 0.0 to 1.0
    let isActive: Bool
    
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Ground/Soil
            RoundedRectangle(cornerRadius: 8)
                .fill(Theme.colors.soilBrown)
                .frame(width: 120, height: 20)
                .offset(y: 60)
            
            // Tree trunk
            RoundedRectangle(cornerRadius: 4)
                .fill(Theme.colors.soilBrown)
                .frame(width: 16, height: trunkHeight)
                .offset(y: trunkOffset)
            
            // Tree foliage (leaves)
            if animatedProgress > 0.1 {
                Circle()
                    .fill(Theme.colors.grassGreen)
                    .frame(width: foliageSize, height: foliageSize)
                    .offset(y: foliageOffset)
            }
            
            if animatedProgress > 0.5 {
                Circle()
                    .fill(Theme.colors.forestGreen)
                    .frame(width: foliageSize * 0.8, height: foliageSize * 0.8)
                    .offset(x: -30, y: foliageOffset - 20)
            }
            
            if animatedProgress > 0.8 {
                Circle()
                    .fill(Theme.colors.forestGreen)
                    .frame(width: foliageSize * 0.7, height: foliageSize * 0.7)
                    .offset(x: 30, y: foliageOffset - 25)
            }
        }
        .frame(width: 150, height: 150)
        .onChange(of: progress) { newValue in
            withAnimation(.easeOut(duration: 0.4)) {
                animatedProgress = newValue
            }
        }
        .onAppear {
            animatedProgress = progress
        }
    }
    
    private var trunkHeight: CGFloat {
        let baseHeight: CGFloat = 20
        let maxHeight: CGFloat = 60
        return baseHeight + (maxHeight - baseHeight) * CGFloat(animatedProgress)
    }
    
    private var trunkOffset: CGFloat {
        return 40 - (trunkHeight / 2)
    }
    
    private var foliageSize: CGFloat {
        let minSize: CGFloat = 20
        let maxSize: CGFloat = 80
        return minSize + (maxSize - minSize) * CGFloat(animatedProgress)
    }
    
    private var foliageOffset: CGFloat {
        return 20 - (foliageSize / 2) - (trunkHeight / 2)
    }
}

#Preview {
    VStack(spacing: 40) {
        TreeView(progress: 0.0, isActive: false)
        TreeView(progress: 0.3, isActive: true)
        TreeView(progress: 0.7, isActive: true)
        TreeView(progress: 1.0, isActive: true)
    }
    .padding()
}
