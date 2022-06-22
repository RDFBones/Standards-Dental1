#! /bin/bash

## BUILD CORE ONTOLOGY

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
      
