set VERSION=1.3
set JAVAPATH="C:\Program Files (x86)\Java\jre6\bin\java"

taskkill /F /T /IM soffice.bin
%JAVAPATH% -jar jetty-runner-7.2.0.v20101020.jar --port 9999  --log daemon.log softing-filebackend-service-%VERSION%.war
