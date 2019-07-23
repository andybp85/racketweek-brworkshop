#lang brag

; based on https://cswr.github.io/JsonSchema/spec/grammar/

JSDoc :  ( id )? ( defs )? JSch 
id : "id" "uri"
defs : "definitions"  kSch ( kSch)*
kSch : kword JSch
kword : KWORD
JSch : ( res ( res)*)
res : type | strRes | numRes | arrRes | objRes | multRes | refSch | title | description
type : "type" ([typename ( typename)*] | typename)
typename : "string" | "integer" | "number" | "boolean" | "null" | "array" | "object"
title : "title" TITLE
description : "description"  DESCR
strRes :  minLen | maxLen | pattern
minLen : "minLength" MINL
maxLen : "maxLength" MAXL
pattern : "pattern" "regExp"
numRes : min | max | multiple 
min : "minimum" MIN (exMin)?
exMin : "exclusiveMinimum" EMIN
max : "maximum" MAX (exMax)?
exMax : "exclusiveMaximum" EMAX
multiple : "multipleOf" MULO
arrRes : items | additems | minitems | maxitems  | unique
items : ( sameitems |  varitems )
sameitems : "items"  JSch 
varitems : "items" [ JSch ( JSch )*] 
additems :  "additionalItems" (ADDITMS |  JSch )
minitems : "minItems" MINITMS
maxitems : "maxItems" MAXITMS
unique : "uniqueItems" UITMS
objRes : prop | addprop | req | minprop | maxprop | dep | pattprop
prop : "properties"  kSch ( kSch)*
addprop : "additionalProperties" (ADDPROPS |  JSch )
req : "required" [ kword (, kword)*]
minprop : "minProperties" MINPROPS
maxprop : "maxProperties" MAXPROPS
dep : "dependencies"  kDep (kDep)*
kDep : (kArr | kSch)
kArr : kword [ kword ( kword)*]
pattprop : "patternProperties"  patSch ( patSch)*
patSch : "regExp"  JSch 
multRes : allOf | anyOf| oneOf | not | enum
anyOf : "anyOf" [  JSch  ( JSch ) * ]
allOf : "allOf" [  JSch  ( JSch ) * ]
oneOf : "oneOf" [  JSch  ( JSch ) * ]
not : "not"  JSch 
enum : "enum" [Jval ( Jval)*]
Jval : JVAL
refSch : "$ref" "uriRef" 
uriRef : ( address )? ;( # / JPointer )?
JPointer : ( / path )
path : ( UNESCD | ESCD )
escaped : ~0 | ~1
address : (SCHEME )? HEIR ( QUERY )* 
