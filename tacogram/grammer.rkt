#lang brag

taco-program : [/"\n"]+ taco-leaf+ [/"\n"]+

taco-leaf : /"#" (taco | not-a-taco){7} /"$"
not-a-taco : /"#" /"$"
taco : /"%"
