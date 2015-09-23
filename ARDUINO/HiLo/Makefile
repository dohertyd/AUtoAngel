#
# Makefile to build Golgi Arduino code
#

JAVA=/usr/bin/java
JAVAC=/usr/bin/javac
#CLASSPATH=$(HOME)/Golgi-Pkg/LATEST/common/garrick_combined.jar
CLASSPATH=$(HOME)/Golgi-Pkg/v2-08-03/common/garrick_combined.jar

all:gen_code
#	@echo "Copying all files libraries"
	@echo ""
#	mkdir -p HiLo
#	mv HiLo.{cpp,h} HiLo/
#	mv libgolgi.{cpp,h} libgolgi/


ether:clean
	@echo "Generating code for ethernet ..."
#	sh ~/Golgi-Pkg/LATEST/Arduino/golgen.sh -lib-ether `cat ../../Golgi.DevKey`  `cat ../../Golgi.AppKey`  ../../AutoAngel.thrift GolgiGen 
	sh ~/Golgi-Pkg/v2-08-03/Arduino/golgen.sh -lib-ether `cat ../../Golgi.DevKey`  `cat ../../Golgi.AppKey`  ../../AutoAngel.thrift GolgiGen 
	@echo "complete"
	@echo ""
wifi:clean
	@echo "Generating code for wifi..."
	sh ~/Golgi-Pkg/v2-08-03/Arduino/golgen.sh -lib-wifi `cat ../../Golgi.DevKey`  `cat ../../Golgi.AppKey`  ../../AutoAngel.thrift GolgiGen 
	@echo "complete"
	@echo ""
serial:clean
	@echo "Generating code for serial ..."
	sh ~/Golgi-Pkg/LATEST/Arduino/golgen.sh -lib-serial `cat ../../GolgiConfig/Golgi.DevKey`  `cat ../../GolgiConfig/Golgi.AppKey`  ../../GolgiConfig/GolgiGreeting.thrift GolgiGen 
	@echo "complete"
	@echo ""
sms:clean
	@echo "Generating code for sms ..."
	sh ~/Golgi-Pkg/LATEST/Arduino/golgen.sh -lib-sms `cat ../../GolgiConfig/Golgi.DevKey`  `cat ../../GolgiConfig/Golgi.AppKey`  ../../GolgiConfig/GolgiGreeting.thrift GolgiGen 
	@echo "complete"
	@echo ""
#golgen.sh {-lib-wifi|-lib-ether|-lib-serial|-lib-sms|-lib-custom|-lib-none} <dev-key> <app-key> <thrift-file> <prefix-for-C++-files>

clean:
	rm -f libgolgi.*
	rm -f GOLGI_KEYS.h
	rm -f GolgiGen.{cpp,h}
