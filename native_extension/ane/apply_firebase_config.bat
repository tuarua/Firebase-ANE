@echo off
SET pathtome=%~dp0
SET SZIP="C:\Program Files\7-Zip\7z.exe"

ren %pathtome%FirebaseANE.ane FirebaseANE.zip
call %SZIP% u %pathtome%FirebaseANE.zip -ir!META-INF\*.xml
ren %pathtome%FirebaseANE.zip FirebaseANE.ane