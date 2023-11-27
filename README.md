# AIXM Business Rules Grammar
This repository provides the reference EBNF grammar for the AIXM business rules (after 2023) and the variants of this grammar that are used in specific tools that wupport the AIXM business rules creation, management and implementation.

## Reference grammar
TBD - the basic grammar, in a standard EBNF notation (might be different from the pegyjs notation). For the moment, there are two main candidates:
- grammar.pegjs

## Variants
### Businee Rules Manager (BRM) editor grammar (PeggyJS.org)
The grammar described here is used for editing the rules, with suport of the "SBVR Assistant" tool in BRM. This uses the library [Peggy](https://peggyjs.org/)
You'll find in this repository 2 main files:
- grammarComplex.pegjs
The only difference between both is that we did integrate auto-tagging in the complex file, formating post-validation the result that peggy offers us.  

#### Testing rules
Their [Online version](https://peggyjs.org/online.html) allow us to test our grammar rules validation system.

## Grammar syntax
### General rules 
|     Element    |     Rule of the   element                                                                                 |
|----------------|-----------------------------------------------------------------------------------------------------------|
|     ( )        |     Group multiple rules elements                                                                         |
|     « »        |     Double quotes surround any string literal to appear   as it in the validated strings                  |
|     *          |     Multiplicity 0-N time of the element just before the asterisk                                         |
|     +          |     Multiplicity 1-N time of the element just before the   plus sign                                      |
|     ?          |     Optionality (0-1) of the element just before the question mark                                        |
|     /          |     “Or” sign between the different possible options                                                      |
|     [ ]        |     Surround a char or group of possible chars/other elements like in   Regular Expression (ie: [a-z])    |
|     {}         |     Post-validation execution                                                                             |

### Multiple values ordering
When multiple values begin with the same characters and are in the same list of options, the ordering is very important! We need to always begin with the longer one like in the following example:
> BooleanOp = ("equal-to-one-of" / "equal-to")

If not set like this, the following rule won't be accepted because the grammar library considers when it finds a perfect match that it doesn't need to read any more option.

### Tagging values
```<RuleName> = <name>:<RulePart> { <js_code using name> }```

Concrete example below, the NounConcept subrule will return the nounConcept, without its initial \$, surrounded by its tags. 
```NounConcept = "$" nc:(NounConceptChars+) { return `<noun_concept>${nc.join('')}</noun_concept>` }```

