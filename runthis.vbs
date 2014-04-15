Const ForAppending = 8

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(".\config\game.cfg", ForAppending)

objFile.WriteLine 
objFile.WriteLine 
objFile.WriteLine("[UnitRenderStyle]")
objFile.WriteLine("inking=0")
objFile.WriteLine("AdvancedReflection=0")
objFile.WriteLine("PerPixelPointLighting=0")

objFile.Close