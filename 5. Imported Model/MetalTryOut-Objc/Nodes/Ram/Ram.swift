import UIKit

@objc class Ram: Node {

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

        self.ambientIntensity = 0.400000
        self.diffuseIntensity = 0.8
        self.specularIntensity = 0.200000
        self.shininess = 45.098039
        
        self.rotationX = Matrix4.degreesToRad(-90.0)

    }

}