#!/bin/bash

all_structs () { 
    #pass this function a url 
    wget  $1 -O /tmp/tmpurl.html
    for i in $(cat /tmp/tmpurl.html | grep "pdbsum" | sed "s/pdbsum\//\n/g" | grep -o "^[0-9][A-Z]\{3\}"); 
    do 
     wget https://files.rcsb.org/download/$i.pdb
    done 
    rm /tmp/tmpurl.html 
}

