#! /bin/bash

## DEFINE OPTIONS

update=0
build=0

function usage {
    echo " "
    echo "usage: $0 [-b][-u]"
    echo " "
    echo "    -b          build owl file"
    echo "    -u          initalize/update submodule"
    echo "    -h -?       print this help"
    echo " "
    
    exit
}

while getopts "bcuh?" opt; do
    case "$opt" in
	
	u)  update=1
	    ;;
	b) build=1
	   ;;       
	?)
	usage
	;;
	h)
	    usage
	    ;;
    esac
done
if [ -z "$1" ]; then
    usage
fi

## PREPARE SUBMODULES

## Check if submodules are initialised

gitchk=$(git submodule foreach 'echo $sm_path `git rev-parse HEAD`')
if [ -z "$gitchk" ];then
    update=1
    echo "Initializing git submodule"
fi

## Initialise and update git submodules

if  [ $update -eq 1 ]; then
    git submodule init
    git submodule update
fi


if [ $build -eq 1 ]; then # Starts build process
    
## BUILD DEPENDENCIES

## Build Core Ontology

cd RDFBones-O/robot

./Script-Build_RDFBones-Robot.sh

cd ../..

## COMPILE TEMPLATE

robot template --template Template_StandardsDental1-Robot.tsv \
      --input results/rdfbones.owl \
      --prefix "standards-dental1: http://w3id.org/rdfbones/ext/standards-dental1/" \
      --prefix "obo: http://purl.obolibrary.org/obo/" \
      --prefix "rdfbones: http://w3id.org/rdfbones/core#" \
      --ontology-iri "http://w3id.org/rdfbones/ext/standards-dental1/standards-dental1.owl" \
      --output results/standards-dental1.owl

## Annotate output

robot annotate --input results/standards-dental1.owl \
      --remove-annotations \
      --ontology-iri "http://w3id.org/rdfbones/ext/standards-dental1/latest/standards-dental1.owl" \
      --version-iri "http://w3id.org/rdfbones/ext/standards-dental1/v0-1/standards-dental1.owl" \
      --annotation dc:creator "Felix Engel" \
      --annotation dc:creator "Stefan Schlager" \
      --annotation owl:versionInfo "0.1" \
      --language-annotation dc:description "This RDFBones ontology extension implements chapter 5, Dental Data Collection 1, from Buikstra & Ubelaker (1994)." en \
      --language-annotation dc:title "Dental Data Collection 1: Inventory, Pathology, and Cultural Modifications" en \
      --language-annotation rdfs:label "Dental Data Collection 1" en \
      --language-annotation rdfs:comment "The RDFBones core ontology, version 0.2 or later, needs to be loaded into the same information system for this ontology extension to work." en \
      --output results/standards-dental1.owl
      
## Quality check of output

robot reason --reasoner ELK \
      --input results/standards-dental1.owl \
  -D results/debug.owl

fi # Ends build process
