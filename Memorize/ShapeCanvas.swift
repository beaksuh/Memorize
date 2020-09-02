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
    private var sketch: ((CGFloat, CGRect) -> Path)? = nil
    private var shapes = [RectangleSketch.Category : RectangleSketch.sketch,
                          CircleSketch.Category : CircleSketch.sketch,
                          DiamondSketch.Category : DiamondSketch.sketch]
    
    init(numberOfShapes: CGFloat, category: String) {
        self.numberOfShapes = numberOfShapes
        sketch = shapes[category]
    }
    
    func path(in rect: CGRect) -> Path {
        sketch!(numberOfShapes, rect)
    }
}

protocol ShapeDrawable {
    static var numberOfShapesLimit: CGFloat { get }
    static func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path
    
    static var Category: String { get }
    var category: String { get }
}

struct RectangleSketch: ShapeDrawable {
    static var numberOfShapesLimit: CGFloat = 3.0
    static var Category = "Rectangle"
    var category: String {
        DiamondSketch.Category
    }
    
    static func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
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
    static var numberOfShapesLimit: CGFloat = 3.0
    static var Category = "Circle"
    var category: String {
        DiamondSketch.Category
    }
    
    
    static func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
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
    
    static func circlePath(center: CGPoint, radius: CGFloat) -> Path {
        var p = Path()
        p.addArc(center: center, radius: radius, startAngle: Angle.degrees(0), endAngle: Angle.degrees(360), clockwise: false)
    
        return p
    }
}


struct DiamondSketch: ShapeDrawable {
    static var numberOfShapesLimit: CGFloat = 3.0
    static var Category = "Diamond"
    var category: String {
        DiamondSketch.Category
    }
    
    static func sketch(numberOfShapes: CGFloat, in rect: CGRect) -> Path {
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

struct Strokify: ShapeModifier {

    @ViewBuilder
    func body(shape: ShapeCanvas) -> some View {
        shape.stroke(lineWidth: 2)
        
    }
}

extension ShapeCanvas {
    func stroke(will apply: Bool, lineWidth: CGFloat = 1) -> some Shape {
        apply ? AnyShape(stroke(lineWidth: lineWidth)) : AnyShape(self)
    }
}


struct ShapeCanvas_Previews: PreviewProvider {
    static var previews: some View {
        ShapeCanvas(numberOfShapes: 3, category: RectangleSketch.Category)
        .fill(Color.red, style: FillStyle(eoFill: true))
    }
}
