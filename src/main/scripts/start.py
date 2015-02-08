#!/usr/bin/python
import subprocess
import os
import sys

def install_war():
    os.mkdir("www")
    os.chdir("www")
    subprocess.call(["jar","xf","../$1"])

warfile = sys.argv[1]
if not os.path.exists("www"):
    print "installing war"
    install_war()
else:
    wwwchange = os.path.getmtime("www")
    warchange= os.path.getmtime(warfile)
    if warchange > wwwchange:
        print "re-installing war"
        subprocess.call(["rm","-rf","www"])
        install_war()
    else:
        print "www is up to date"
        os.chdir("www")

CP = "WEB-INF/classes"

results = [f for f in os.listdir("WEB-INF/lib") if f.endswith(".jar")]
for f in results:
    CP = CP + ":WEB-INF/lib/"+ f
if os.path.exists("www"):
    os.chdir("www")
#os.chdir("WEB-INF")
#os.chdir("classes")
print CP
print os.getcwd()
subprocess.call(["java","-verbose:cp","-cp",CP,"com.hexa.robotics.Main", "production"])