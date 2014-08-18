#!/bin/sh
# amoneger: 01-04-2012

w="/usr/bin/whereis"

$("$w" flex) -i acl.l
$("$w" bison) -d acl.y
$("$w" cc) lex.yy.c acl.tab.c -o acl -D DEBUG
