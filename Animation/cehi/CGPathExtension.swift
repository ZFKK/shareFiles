//
//  CGPathExtension.swift
//  cehi
//
//  Created by sunkai on 16/8/15.
//  Copyright © 2016年 imo. All rights reserved.
//

import Foundation
import Cocoa

public enum PathElement {
    case MoveToPoint(CGPoint)
    case AddLineToPoint(CGPoint)
    case AddQuadCurveToPoint(CGPoint, CGPoint)
    case AddCurveToPoint(CGPoint, CGPoint, CGPoint)
    case CloseSubpath
    
    init(element: CGPathElement) {
        switch element.type {
        case .MoveToPoint:
            self = .MoveToPoint(element.points[0])
        case .AddLineToPoint:
            self = .AddLineToPoint(element.points[0])
        case .AddQuadCurveToPoint:
            self = .AddQuadCurveToPoint(element.points[0], element.points[1])
        case .AddCurveToPoint:
            self = .AddCurveToPoint(element.points[0], element.points[1], element.points[2])
        case .CloseSubpath:
            self = .CloseSubpath
        }
    }
}

extension PathElement : CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .MoveToPoint(point):
            return "\(point.x) \(point.y) moveto"
        case let .AddLineToPoint(point):
            return "\(point.x) \(point.y) lineto"
        case let .AddQuadCurveToPoint(point1, point2):
            return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) quadcurveto"
        case let .AddCurveToPoint(point1, point2, point3):
            return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) \(point3.x) \(point3.y) curveto"
        case .CloseSubpath:
            return "closepath"
        }
    }
}

extension PathElement : Equatable { }

public func ==(lhs: PathElement, rhs: PathElement) -> Bool {
    switch(lhs, rhs) {
    case let (.MoveToPoint(l), .MoveToPoint(r)):
        return l == r
    case let (.AddLineToPoint(l), .AddLineToPoint(r)):
        return l == r
    case let (.AddQuadCurveToPoint(l1, l2), .AddQuadCurveToPoint(r1, r2)):
        return l1 == r1 && l2 == r2
    case let (.AddCurveToPoint(l1, l2, l3), .AddCurveToPoint(r1, r2, r3)):
        return l1 == r1 && l2 == r2 && l3 == r3
    case (.CloseSubpath, .CloseSubpath):
        return true
    case (_, _):
        return false
    }
}


//extension NSBezierPath {
//    var elements: [PathElement] {
//        var pathElements = [PathElement]()
//        withUnsafeMutablePointer(pathElements) { elementsPointer in
//            CGPathApply(CGPath, elementsPointer) { (userInfo, nextElementPointer) in
//                let nextElement = PathElement(element: nextElementPointer.memory)
//                let elementsPointer = UnsafeMutablePointer<[PathElement]>(userInfo)
//                elementsPointer.memory.append(nextElement)
//            }
//        }
//        return pathElements
//    }
//}


//extension NSBezierPath : SequenceType {
//    public func generate() -> AnyGenerator<PathElement> {
//        return anyGenerator(elements.generate())
//    }
//}


//extension NSBezierPath : CustomDebugStringConvertible {
//    public override var debugDescription: String {
//        let cgPath = self.CGPath;
//        let bounds = CGPathGetPathBoundingBox(cgPath);
//        let controlPointBounds = CGPathGetBoundingBox(cgPath);
//        
//        let description = "\(self.dynamicType)\n"
//            + "    Bounds: \(bounds)\n"
//            + "    Control Point Bounds: \(controlPointBounds)"
//            + elements.reduce("", combine: { (acc, element) in
//                acc + "\n    \(String(reflecting: element))"
//            })
//        return description
//    }
//}