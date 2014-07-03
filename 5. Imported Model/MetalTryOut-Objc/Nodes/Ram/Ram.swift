import UIKit

@objc class Ram: Model {

    init(baseEffect: BaseEffect)
    {

        var verticesArray:Array<Vertex> = []
        let path = NSBundle.mainBundle().pathForResource("ram", ofType: "txt")
            var possibleContent = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)

            if let content = possibleContent {
            var array = content.componentsSeparatedByString("\n")
            array.removeLast()
            for line in array{
                var vertex = Vertex(text: line)
                verticesArray.append(vertex)
            }
        }


        super.init(name: "Ram", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "char_ram_col.jpg")

        self.ambientIntensity = 0.000000
        self.diffuseIntensity = 0.259223
        self.specularIntensity = 0.200000
        self.shininess = 45.098039

    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        rotationZ += Float(M_PI/8) * Float(delta)
    }

}