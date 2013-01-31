#!/bin/bash

wget www.onemanga.com/$1 -O manga
manganame=`cat manga | grep ch-subject | awk 'NR==2' | awk -F"/" '{ print $2}'`
mangachapter=`cat manga | grep ch-subject | awk 'NR==2' | awk -F"/" '{ print $3}'`
mkdir $manganame
cd $manganame
mkdir $mangachapter
cd ..
wget www.onemanga.com/$1/$mangachapter -O step1
cat step1 | grep Begin | awk ' BEGIN {FS ="\""} {print $2}'
step6=""
until [ "$step6" == "credits" ]
do
	if [ "$step5" == "" ];
	then step2=`cat step1 | grep Begin | awk ' BEGIN {FS ="\""} {print $2}'`
	else step2=$step5
	fi
	wget www.onemanga.com$step2 -O step3
	step4=`cat step3 | grep onemanga.com/mangas | grep src= | awk ' BEGIN {FS ="\""} {print $4}'`
	wget $step4 -P ./$manganame/$mangachapter
	step5=`cat step3 | grep "var next" | awk ' BEGIN {FS ="'"'"'"} {print $2}'`
	step6=`cat step3 | grep "var next" | awk ' BEGIN {FS ="'"'"'"} {print $2}' | awk 'BEGIN {FS ="/"} {print $4}'`
done
rm step1
rm step3
rm manga