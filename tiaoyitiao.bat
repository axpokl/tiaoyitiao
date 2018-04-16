del *.zip
del *.ppu
del *.o
del *.or
del *.a
del *.exe
del *.png
del tiaoyitiao.exe
del tiaoyitiao.zip
fpc tiaoyitiao.pas -otiaoyitiao.exe -Os
if not exist tiaoyitiao.exe pause
if not exist tiaoyitiao.exe exit
mkdir tiaoyitiao
copy tiaoyitiao.exe tiaoyitiao\tiaoyitiao.exe
copy tiaoyitiao.ini tiaoyitiao\tiaoyitiao.ini
copy tiaoyitiao.pas tiaoyitiao\tiaoyitiao.pas
copy README.md tiaoyitiao\README.md
copy LICENSE tiaoyitiao\LICENSE
copy display.pp tiaoyitiao\display.pp
zip -q -r tiaoyitiao.zip tiaoyitiao
rmdir tiaoyitiao /s /q
del *.obj
del *.ppu
del *.o
del *.or
del *.a