@echo off
SET pathtome=%~dp0
SET SZIP="C:\Program Files\7-Zip\7z.exe"

ren %pathtome%extensions\FirebaseANE.ane FirebaseANE.zip
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.xml
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.png
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.gif
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.jpg
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.mp3
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.wav
call %SZIP% u %pathtome%extensions\FirebaseANE.zip -ir!META-INF\*.mp4
ren %pathtome%extensions\FirebaseANE.zip FirebaseANE.ane