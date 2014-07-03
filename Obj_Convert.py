import sys, os

def upcase_first_letter(s):
    return s[0].upper() + s[1:]

scriptPath = os.path.realpath(__file__)
scriptDirPath = os.path.dirname(scriptPath)

arguments = sys.argv

className = str(arguments[1])
className = upcase_first_letter(className)

fileNameObj = scriptDirPath+'/'+className+'.obj'
fileNameMtl = fileNameObj.replace('obj','mtl')

fileObj = open(fileNameObj,'r')

positionList = list()
texCoordList = list()
normalList = list()

facesLinesList = list()

line = fileObj.readline()


while line!='':
        if line.startswith('vn '):
                string = line.replace('vn ','')
                string = string.replace('\n','')
                normalList.append(string)
        elif line.startswith('v '):
                string = line.replace('v ','')
                string = string.replace('\n','')
                positionList.append(string)
        elif line.startswith('f '):
                string = line.replace('f ','')
                string = string.replace('\n','')
                facesLinesList.append(string)
        elif line.startswith('vt '):
                string = line.replace('vt ','')
                string = string.replace('\n','')
                texCoordList.append(string)
        elif line.startswith('mtllib '):
                string = line.replace('mtllib ','')
                string = string.replace('\n','')
        line = fileObj.readline()

fileObj.close()

positionCoordsComponentsList = list()
for line in positionList:
        positionCoordsComponentsList.append(line.split(' '))

textureCoordComponentsList = list()
for line in texCoordList:
        textureCoordComponentsList.append(line.split(' '))

normalCoordsComponentsList = list()
for line in normalList:
        normalCoordsComponentsList.append(line.split(' '))

facesList = list()
for line in facesLinesList:
        list3F = line.split(' ')
        facesList.append(list3F[0].split('/'))
        facesList.append(list3F[1].split('/'))
        facesList.append(list3F[2].split('/'))

numberOfVertices = len(facesList)

swiftFilePath = fileNameObj.replace('obj','swift')
fileSwift = open(swiftFilePath,'w')
fileSwift.write('import UIKit' + '\n\n' + '@objc class ' + className + ': Model {')
fileSwift.write('\n\n    init(baseEffect: BaseEffect)\n    {\n')

fileSwift.write('\n        var verticesArray:Array<Vertex> = []\n')
fileSwift.write('''        let path = NSBundle.mainBundle().pathForResource("''' +className.lower()+'''", ofType: "txt")\n''')
fileSwift.write('            var possibleContent = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)\n\n')
fileSwift.write('            if let content = possibleContent {\n')
fileSwift.write('''            var array = content.componentsSeparatedByString("\\n")\n''')
fileSwift.write('            array.removeLast()\n')
fileSwift.write('            for line in array{\n')
fileSwift.write('                var vertex = Vertex(text: line)\n')
fileSwift.write('                verticesArray.append(vertex)\n')
fileSwift.write('            }\n')
fileSwift.write('        }\n')


fileSwift.write('\n\n')

fileMtl = open(fileNameMtl,'r')
line = fileMtl.readline()

shininess = ''
ambientIntensity = ''
diffuseIntensity = ''
specularIntensity = ''
textureFileName = ''

while line!='':
        if line.startswith('Ns '):
                string = line.replace('Ns ','')
                string = string.replace('\n','')
                shininess = string
        elif line.startswith('Ka '):
                string = line.replace('Ka ','')
                string = string.replace('\n','')
                ambientList = string.split(' ')
                ambientIntensity = str(ambientList[0])
        elif line.startswith('Kd '):
                string = line.replace('Kd ','')
                string = string.replace('\n','')
                diffuseList = string.split(' ')
                diffuseIntensity = str(diffuseList[0])
        elif line.startswith('Ks '):
                string = line.replace('Ks ','')
                string = string.replace('\n','')
                specularList = string.split(' ')
                specularIntensity = str(specularList[0])
        elif line.startswith('map_Kd '):
                string = line.replace('map_Kd ','')
                string = string.replace('\n','')
                textureFileName = string
        
        line = fileMtl.readline()

fileObj.close()

fileSwift.write('''        super.init(name: "'''+ className +'''", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "'''+textureFileName+'''")''')


fileSwift.write('\n\n')
fileSwift.write('        self.ambientIntensity = '+ambientIntensity+'\n')
fileSwift.write('        self.diffuseIntensity = '+diffuseIntensity+'\n')
fileSwift.write('        self.specularIntensity = '+specularIntensity+'\n')
fileSwift.write('        self.shininess = '+shininess)

fileSwift.write('\n\n    }')
fileSwift.write('\n\n}')

fileSwift.close()

fileTxtName = scriptDirPath+'/'+className.lower()+'.txt'
fileTxt = open(fileTxtName,'w')


for i in range(numberOfVertices):
        face = facesList[i]
        x = str(positionCoordsComponentsList[int(face[0])-1][0])
        y = str(positionCoordsComponentsList[int(face[0])-1][1])
        z = str(positionCoordsComponentsList[int(face[0])-1][2])
        u = str(textureCoordComponentsList[int(face[1])-1][0])
        v = str(textureCoordComponentsList[int(face[1])-1][1])
        nX = str(normalCoordsComponentsList[int(face[2])-1][0])
        nY = str(normalCoordsComponentsList[int(face[2])-1][1])
        nZ = str(normalCoordsComponentsList[int(face[2])-1][2])
        vStr = x+' '+y+' '+z+' '+u+' '+v+' '+nX+' '+nY+' '+nZ+'\n'
        fileTxt.write(vStr)
fileTxt.close()

