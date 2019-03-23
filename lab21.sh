#!/bin/bash

ME_N=$(basename $0)
VERC=1.0

oshibka () {
printf "${ME_N}: $1.\nНапишите '$ME_N —help' для получения информации.\n" >&2
exit 1
return
}

prog_verc () {
cat « _EOF_
$ME_N: $VERC

This is free software. You can modify and distribute it. Enjoy your use.

2019

_EOF_
exit 0
return
}

prog_help () {
cat « _EOF_
$ME_N -p префикс -d директория
Переименование всех файлов с указанным суффиксом путем добавления к ним заданного префикса.

Аргументы, обязательные для длинных ключей, обязательны и для коротких.
-d, —directory директория в которой будут производиться все действия
-p, —prefix префикс
—help показать эту справку и выйти
—version показать информацию о версии и выйти

Коды выхода:
0 всё сработало,
1 маленькая проблема,
2 серьёзная проблема.
_EOF_
exit 0
return
}

MY_DIRECTORY=""
PREFIX=""
VERBOSE=0

while [[ -n "$1" ]]
do
case "$1" in
-d | —directory)
path=$2
if [[ -d $path ]]
then
MY_DIRECTORY=$(realpath $path)
else
oshibka "'$path' не является директорией"
fi
shift
;;
-p | —prefix)
prefix=$2
if [[ -n $prefix ]]
then
PREFIX=$prefix
else
oshibka "'$prefix' не является префиксом"
fi
shift
;;
-h | —help)
prog_help
;;
—version)
prog_verc
;;
-v | —verbose)
VERBOSE=1
;;
*)
oshibka "$1 такой опции не существует"
;;
esac
shift
done

for file in $(find $MY_DIRECTORY -name '*')
do
if [[ $file == $MY_DIRECTORY ]]
then
continue
fi

dir=$(dirname "$file")
base=$(basename "$file")
new="$dir/${PREFIX}$base"
mv "$file" "$new"

if (( $VERBOSE == 1 && $? == 0 ))
then
echo "$file -> $new"
fi
done
