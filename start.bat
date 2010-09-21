del %AppData%\Local\Temp\inprint.lock
del %AppData%\Local\Temp\inprint.pid

start perl script/my_mojolicious_app daemon --reload