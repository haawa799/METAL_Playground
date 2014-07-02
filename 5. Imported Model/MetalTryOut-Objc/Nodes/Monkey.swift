import UIKit

@objc class Monkey: Model {

    init(baseEffect: BaseEffect)

    {

        var verticesArray:Array<Vertex> = []
        let path = NSBundle.mainBundle().pathForResource("monkey", ofType: "txt")
            var possibleContent = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)

            if let content = possibleContent {
            var array = content.componentsSeparatedByString("\n")
            array.removeLast()
            for line in array{
                var vertex = Vertex(text: line)
                verticesArray.append(vertex)
            }
        }


        super.init(name: "Monkey", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "monkey.png")

        self.ambientIntensity = 0.000000
        self.diffuseIntensity = 0.640000
        self.specularIntensity = 0.500000
        self.shininess = 96.078431
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
        //        rotationZ += Float(M_PI/10) * Float(delta)
        rotationX += Float(M_PI/2) * Float(delta)
    }

}