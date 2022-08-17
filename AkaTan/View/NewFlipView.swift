//
//  NewFlipView.swift
//  AkaTan
//
//  Created by Nobuhiro Akahoshi on 2022/08/17.
//

import SwiftUI

struct NewFlipView<Front: View, Back: View>: View {
    
    let front: () -> Front
    let back: () -> Back
    
    var isFront: Bool
    @State private var rotationValue: Double = 0
    var intFormatter: Formatter = NumberFormatter()
    
    init(
        _ isFront: Bool = true,
        @ViewBuilder front: @escaping () -> Front,
        @ViewBuilder back: @escaping () -> Back)
    {
        self.isFront = isFront
        self._rotationValue = State(initialValue: isFront ? 0 : 180)
        self.front = front
        self.back = back
    }
    
    var body: some View {
        VStack {
            // ローテーション
            ZStack {
                if rotationValue > 80 {
                    back()
                        .rotation3DEffect(Angle(degrees: rotationValue - 180), axis: (x: 0, y: 1, z: 0))
                }
                if rotationValue <= 90 {
                    front()
                        .rotation3DEffect(Angle(degrees: rotationValue), axis: (x: 0, y: 1, z: 0))
                }
            }
            .onChange(of: self.isFront) { value in
                rotateCard()
                print("Changed")
            }
            /*
            // スライダー
            Slider(
                value: $rotationValue,
                in: 0...180,
                step: 10,
                minimumValueLabel: Text("0°"),
                maximumValueLabel: Text("180°"),
                label: {
                    // ラベルのView並び
                })
            Text("\(rotationValue, specifier: "%.0f")°")
                .padding()
            Text("\(isFront ? "表" : "裏")")
            
            Button(action: {
                //rotateCard()
                //self.isFront.toggle()
            }) {
                Text("回転")
                    .fontWeight(.semibold)
                    .frame(width: 160, height: 48)
                    .foregroundColor(Color(.white))
                    .background(.blue)
                    .cornerRadius(24)
            }
             */
        }
        .padding()
    }
    
    func rotateCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            withAnimation(.linear(duration: 0.3)) {
                self.rotationValue = self.isFront ? 90 : 90
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.linear(duration: 0.7)) {
                self.rotationValue = self.isFront ? 180 : 0
                //self.isFront.toggle()
            }
        }
    }
}


func FrontView() -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 10)
            .fill(.blue)
            .frame(width: .infinity, height: 150)
        Text("表面")
            .font(.title)
            .foregroundColor(.white)
    }
}

func BackView() -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 10)
            .fill(.red)
            .frame(width: .infinity, height: 150)
        Text("裏面")
            .font(.title)
            .foregroundColor(.white)
    }
}


struct NewFlipView_Previews: PreviewProvider {
    static var previews: some View {
        NewFlipView(
            front: {
                FrontView()
            }, back: {
                BackView()
            })
    }
}
