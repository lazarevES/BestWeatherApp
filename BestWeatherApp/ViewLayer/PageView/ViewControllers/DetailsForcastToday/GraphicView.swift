//
//  GraphicView.swift
//  BestWeatherApp
//
//  Created by Егор Лазарев on 09.08.2022.
//

import Foundation
import UIKit

class GraphicView: UIView {
    
    private var forecast = [(date: String, hour: Hour)]()
    private var points = [CGPoint]()
    private var graphPoints = [Hour]()
    
    private lazy var labelTemp: [UILabel] = {
        var label = [UILabel]()
        for i in 0...7 {
            label.append(UILabel.getlabel(14, .center, .black, "", false))
        }
        return label
    }()
    
    private lazy var image: [UIImageView] = {
        var image = [UIImageView]()
        for i in 0...7 {
            image.append(UIImageView.getImage("", toAutoLayot: false))
        }
        return image
    }()
    
    private lazy var humiditylabel: [UILabel] = {
        var label = [UILabel]()
        for i in 0...7 {
            label.append(UILabel.getlabel(12, .center, .black, "", false))
        }
        return label
    }()
    
    private lazy var timelabel: [UILabel] = {
        var label = [UILabel]()
        for i in 0...7 {
            label.append(UILabel.getlabel(14, .center, .black, "", false))
        }
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        labelTemp.forEach { label in
            addSubview(label)
        }
        image.forEach { image in
            addSubview(image)
        }
        humiditylabel.forEach { label in
            addSubview(label)
        }
        timelabel.forEach { label in
            addSubview(label)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConten(_ forecast: [(date: String, hour: Hour)]) {
        self.forecast = forecast
        
        graphPoints = [Hour]()
        
        var index = 0
        var indexLabel = 0
        
        while index < forecast.count {
            
            let hour = forecast[index].hour
            labelTemp[indexLabel].text = hour.tempString
            image[indexLabel].image = hour.wheatherIcon.getImage()
            humiditylabel[indexLabel].text = String(hour.humidity) + "%"
            timelabel[indexLabel].text = hour.hourString
            graphPoints.append(hour)
            indexLabel += 1
            index += 3
        }
    }
    
    //Говнокод скопированный и с 100500 сайтов =)
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let colors = [ConstValue.backgroundColor.cgColor,  ConstValue.backgroundColorLight.cgColor]
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5
        guard let gradient = CGGradient(
            colorsSpace: colorSpace,
            colors: colors as CFArray,
            locations: colorLocations
        ) else {
            return
        }
        
        var graphPoints = [Int]()
        
        if self.graphPoints.count > 0 {
            self.graphPoints.forEach { hour in
                graphPoints.append(hour.temp)
            }
        } else {
            graphPoints.append(0)
        }
        
        let width = rect.width
        let height: CGFloat = 90
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        guard let maxValue = graphPoints.max() else {
            return
        }
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + Constants.topBorder - yPoint // Переворот графика
        }
        
        let color = ConstValue.backgroundColor
        color.setStroke()
        
        let linePath = UIBezierPath()
        
        // Боковая линия
        linePath.move(to: CGPoint(x: margin, y: columnYPoint(graphPoints[0])))
        linePath.addLine(to: CGPoint(x: margin, y: height + 3))
        
        // Нижняя линия
        linePath.move(to: CGPoint(x: margin, y: height + 3))
        linePath.addLine(to: CGPoint(x: width - margin, y: height + 3))
        color.setStroke()
        
        let  dashes: [CGFloat] = [4.0,8.0]
        linePath.setLineDash(dashes, count: dashes.count, phase: 0.0)
        linePath.lineCapStyle = .round
        linePath.lineWidth = 3.0
        linePath.stroke()
        
        var secondLinePath = UIBezierPath()
        secondLinePath.move(to: CGPoint(x: margin, y: rect.height - 40))
        secondLinePath.addLine(to: CGPoint(x: width - margin, y: rect.height - 40))
        
        color.setStroke()
        
        secondLinePath.lineWidth = 1.0
        secondLinePath.stroke()
        
        secondLinePath = UIBezierPath()
        
        for i in 0 ..< graphPoints.count {
            let point = CGPoint(x: columnXPoint(i), y: rect.height - 40)
            
            secondLinePath.move(to: CGPoint(x: point.x, y: point.y - 5))
            secondLinePath.addLine(to: CGPoint(x: point.x, y: point.y + 5))
        }
        
        color.setStroke()
        
        secondLinePath.lineWidth = 3.0
        secondLinePath.stroke()
        
        UIColor.white.setFill()
        
        // Задание точек графика
        let graphPath = UIBezierPath()
        
        // Идем на начало линии графика
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // Добавляем точки для каждого элемента в массиве graphPointsAdd
        // в соответсвующие точки (x, y)
        for i in 1 ..< graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        // Создаем траекторию обрезания для градиента графика
        
        // 1 - Сохраняем состояние контекста (commented out for now)
        context.saveGState()
        
        // 2 - Создаем копию кривой
        guard let clippingPath = graphPath.copy() as? UIBezierPath else {
            return
        }
        
        // 3 - Добавляем линии в скопированную кривую для завершения обрезаемой области
        clippingPath.addLine(to: CGPoint(
            x: columnXPoint(graphPoints.count - 1),
            y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        // 4 - Добавляем обрезающую кривую в контекст
        clippingPath.addClip()
        
        let graphStartPoint = CGPoint(x: margin, y: 0)
        let graphEndPoint = CGPoint(x: margin, y: 90)
        
        context.drawLinearGradient(
            gradient,
            start: graphStartPoint,
            end: graphEndPoint,
            options: [])
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // Draw the circles on top of the graph stroke
        for i in 0 ..< graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            self.points.append(point)
            
            let circle = UIBezierPath(
                ovalIn: CGRect(
                    origin: point,
                    size: CGSize(
                        width: Constants.circleDiameter,
                        height: Constants.circleDiameter)
                )
            )
            circle.fill()
        }
        
        useConstraint()
        super.draw(rect)
        
    }
    
    private func useConstraint() {
        
        var index = 0
        var indexLabel = 0
        
        while index < forecast.count {
            let point = self.points[indexLabel]
            labelTemp[indexLabel].frame = CGRect(x: point.x - 10, y: point.y - 20, width: 30, height: 14)
            image[indexLabel].frame = CGRect(x: point.x - 3, y: 100, width: 15, height: 15)
            humiditylabel[indexLabel].frame = CGRect(x: point.x - 21, y: 115, width: 50, height: 14)
            timelabel[indexLabel].frame = CGRect(x: point.x - 24, y: 155, width: 60, height: 14)
            
            index += 3
            indexLabel += 1
        }
    }
    
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 40
        static let bottomBorder: CGFloat = 0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 10.0
    }
    
}
