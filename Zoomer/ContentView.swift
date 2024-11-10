//
//  ContentView.swift
//  Zoomer
//
//  Created by シン・ジャスティン on 2024/11/10.
//

import SwiftUI

struct ContentView: View {
    @State var currentMagnification: CGFloat = 1.0
    @State var provisionalMagnification: CGFloat = 0.0
    @State var magnificationAnchor: UnitPoint = .topLeading

    let magnificationLowerLimit = 0.2
    let magnificationUpperLimit = 1.0

    let symbols: [String: UnitPoint] = [
        "airplane": UnitPoint(x: 432, y: 1182),
        "ant": UnitPoint(x: 982, y: 723),
        "bell": UnitPoint(x: 1085, y: 295),
        "bicycle": UnitPoint(x: 137, y: 467),
        "bolt": UnitPoint(x: 1259, y: 1260),
        "bookmark": UnitPoint(x: 923, y: 508),
        "calendar": UnitPoint(x: 332, y: 1045),
        "camera": UnitPoint(x: 1120, y: 129),
        "cart": UnitPoint(x: 815, y: 1135),
        "cloud": UnitPoint(x: 1221, y: 844),
        "doc": UnitPoint(x: 245, y: 682),
        "envelope": UnitPoint(x: 360, y: 1205),
        "flag": UnitPoint(x: 1200, y: 340),
        "flame": UnitPoint(x: 590, y: 930),
        "folder": UnitPoint(x: 750, y: 500),
        "gift": UnitPoint(x: 205, y: 670),
        "heart": UnitPoint(x: 1300, y: 1245),
        "house": UnitPoint(x: 655, y: 1200),
        "leaf": UnitPoint(x: 945, y: 765),
        "link": UnitPoint(x: 1020, y: 255),
        "lock": UnitPoint(x: 1175, y: 450),
        "map": UnitPoint(x: 300, y: 800),
        "mic": UnitPoint(x: 865, y: 615),
        "moon": UnitPoint(x: 1080, y: 1300),
        "paperclip": UnitPoint(x: 140, y: 330),
        "pencil": UnitPoint(x: 980, y: 1000),
        "phone": UnitPoint(x: 675, y: 1035),
        "star": UnitPoint(x: 1220, y: 490),
        "sun.min": UnitPoint(x: 380, y: 1300),
        "trash": UnitPoint(x: 760, y: 250),
        "umbrella": UnitPoint(x: 1095, y: 1185),
        "wifi": UnitPoint(x: 510, y: 895),
        "wrench": UnitPoint(x: 130, y: 1325)
    ]

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            ZStack(alignment: .topLeading) {
                Image(.sample)
                    .resizable()
                    .frame(width: 1400.0, height: 1400.0, alignment: .topLeading)
                ForEach(symbols.keys.sorted(), id: \.self) { key in
                    Image(systemName: key)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color(red: Double.random(in: 0.0..<1.0),
                                               green: Double.random(in: 0.0..<1.0),
                                               blue: Double.random(in: 0.0..<1.0),
                                               opacity: 0.5))
                        .frame(width: 60.0, height: 60.0, alignment: .center)
                        .padding()
                        .background(.regularMaterial)
                        .overlay {
                            Rectangle()
                                .strokeBorder(.primary, lineWidth: 4.0)
                        }
                        .position(
                            x: CGFloat(symbols[key]?.x ?? 0.0),
                            y: CGFloat(symbols[key]?.y ?? 0.0)
                        )
                        .id(key)
                }
            }
            .scaleEffect(currentMagnification + provisionalMagnification, anchor: .center)
            .frame(
                width: 1400.0 * (currentMagnification + provisionalMagnification),
                height: 1400.0 * (currentMagnification + provisionalMagnification)
            )
        }
        .gesture(
            MagnifyGesture()
                .onChanged { gesture in
                    let originalMagnification = gesture.magnification - 1.0
                    let expectedMagnification = currentMagnification + originalMagnification
                    if expectedMagnification < magnificationLowerLimit {
                        let molassedMagnification = expectedMagnification - magnificationLowerLimit
                        let regularMagnification = originalMagnification - molassedMagnification
                        provisionalMagnification = regularMagnification + (molassedMagnification / 10.0)
                    } else if expectedMagnification > magnificationUpperLimit {
                        let molassedMagnification = expectedMagnification - magnificationUpperLimit
                        let regularMagnification = originalMagnification - molassedMagnification
                        provisionalMagnification = regularMagnification + (molassedMagnification / 10.0)
                    } else {
                        provisionalMagnification = originalMagnification
                    }
                    magnificationAnchor = gesture.startAnchor
                }
                .onEnded { gesture in
                    withAnimation(.smooth.speed(2.0)) {
                        let finalMagnificationState = currentMagnification + provisionalMagnification
                        if finalMagnificationState < 0.2 {
                            currentMagnification = 0.2
                        } else if finalMagnificationState > 1.0 {
                            currentMagnification = 1.0
                        } else {
                            currentMagnification += provisionalMagnification
                        }
                        provisionalMagnification = .zero
                    } completion: {
                        magnificationAnchor = .topLeading
                    }
                }
        )
    }
}
