//
//  ShapeSet.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/25.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

struct ShapeCanvas: Shape {
    private var numberOfShapes: CGFloat
    private var sketch: (CGFloat, CGRect) -> Path
    
    init(numberOfShapes: CGFloat, sketch: @escaping (CGFloat, CGRect) -> Path) {
        self.numberOfShapes = numberOfShapes
        self.sketch = sketch
    }
    
    func path(in rect: CGRect) -> Path {
        sketch(numberOfShapes, rect)
    }
}

protocol ShapeDrawable {
    var numberOfShapesLimit: CGFloat { get }
    func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path
}

struct RectangleSketch: ShapeDrawable {
    let numberOfShapesLimit: CGFloat = 3.0
    
    func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
        var p = Path()
        
        let width = rect.width/(numberOfShapesLimit+1)
        let height = rect.height/(numberOfShapesLimit+1)
        let spacing = width / 5
        let size = CGSize(width: width, height: height)
        var startX = (rect.width-width*numberOfShapes-spacing*(numberOfShapes-1)) / 2
        
        for _ in 0..<Int(numberOfShapes) {
            let origin = CGPoint(x: startX, y: rect.midY - height/2)
            let shapeRect = CGRect(origin: origin, size: size)
            p.addRoundedRect(in: shapeRect, cornerSize: CGSize(width: size.width/5, height: size.width/5))
            startX = startX + width + spacing
        }

        return p
    }
}

struct CircleSketch: ShapeDrawable {
    let numberOfShapesLimit: CGFloat = 3.0
    
    func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
        var p = Path()
        
        let height = rect.height/(numberOfShapesLimit + 1)
        let spacing = height / 5
        let radius = (height) / 2
        var centerY = ((rect.height - height * numberOfShapes - (spacing * numberOfShapes - 1)) / 2) + radius
        
        for _ in 0..<Int(numberOfShapes) {
            let center = CGPoint(x: rect.midX, y: centerY)
            p.addPath(circlePath(center: center, radius: radius))
            centerY = centerY + height + spacing
        }
        
        return p
    }
    
    func circlePath(center: CGPoint, radius: CGFloat) -> Path {
        var p = Path()
        p.addArc(center: center, radius: radius, startAngle: Angle.degrees(0), endAngle: Angle.degrees(360), clockwise: false)
    
        return p
    }
}


struct DiamondSketch: ShapeDrawable {
    let numberOfShapesLimit: CGFloat = 3.0
    func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
        var p = Path()

        
        let width = rect.width/(numberOfShapesLimit+1)
        let radius = width / 2
        var startX = ((rect.width - width * numberOfShapes) / 2) + radius
        var startYOffset = rect.midY - numberOfShapes * radius

        for _ in 0..<Int(numberOfShapes) {
            let top = CGPoint(x: startX, y: startYOffset)
            let bottom = CGPoint(x: startX, y: startYOffset + width)
            let left = CGPoint(x: startX - radius, y: startYOffset + radius)
            let right = CGPoint(x: startX + radius, y: startYOffset + radius)

            p.move(to: top)
            p.addLine(to: left)
            p.addLine(to: bottom)
            p.addLine(to: right)
            p.addLine(to: top)
            
            startX = startX + width
            startYOffset = startYOffset + width
        }

        return p
    }
}

struct FlowerSketch: ShapeDrawable {
    let numberOfShapesLimit: CGFloat = 3.0
    var petalOffset: Double = -20
    var petalWidth: Double = 100
    
    func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
        var p = Path()
        for number in stride(from: 0, through: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position =
                rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))

            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset), y: 0, width: CGFloat(petalWidth), height: rect.width / 2))

            let rotatedPetal = originalPetal.applying(position)

            p.addPath(rotatedPetal)
        }
        return p
    }
}

struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}

protocol ShapeModifier {
    associatedtype Body : View

    func body(shape: ShapeCanvas) -> Self.Body
}

extension ShapeCanvas {
    func modifier<M>(_ modifier: M) -> some View where M: ShapeModifier {
        modifier.body(shape: self)
    }
}

extension ShapeCanvas {
    func stroke(will apply: Bool, lineWidth: CGFloat = 1) -> some Shape {
        apply ? AnyShape(stroke(lineWidth: lineWidth)) : AnyShape(self)
    }
}

struct Strokify: ShapeModifier {
    
    @ViewBuilder
    func body(shape: ShapeCanvas) -> some View {
        
    }
}

struct ShapeCanvas_Previews: PreviewProvider {
    static var previews: some View {
        ShapeCanvas(numberOfShapes: 3, sketch: RectangleSketch().sketch)
        .fill(Color.red, style: FillStyle(eoFill: true))
    }
}
