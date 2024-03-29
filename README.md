# AIXM Business Rules Grammar
This repository provides the reference EBNF grammar for the AIXM business rules (after end 2023) and the variants of this grammar that are used in specific tools that support the AIXM business rules creation, management and implementation.

## Reference grammar
This is the basic grammar, in a standard EBNF notation: [Peggy_rule_verification](https://github.com/aixm/Business-Rules-Grammar/blob/main/Peggy_rule_verification)

For the moment, a notation that is specific to the [Peggy](https://peggyjs.org/) (Parser Generator for JavaScript) and it includes some Peggy functions that allow to identify the elementary condition used in the rule. 
This is a temporary situation, due to the use of Peggy in the Eurocontrol Business Rules Editor (BRM). Once the grammar is finalised, a more standard EBNF notation will be applied.

### Peggy BNF notation
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

### Peggy specific aspects (might be valid for other BNF tools also)
#### Multiple values ordering 
When multiple values begin with the same characters and are in the same list of options, the ordering is very important! We need to always begin with the longer one like in the following example:
> BooleanOp = ("equal-to-one-of" / "equal-to")
If not set like this, the following rule won't be accepted because the grammar library considers when it finds a perfect match that it doesn't need to read any more option.
#### Testing rules
The [PeggyJS.org online version](https://peggyjs.org/online.html) allows to test the rules agains the grammar.

## Variants
### BRM editor grammar (Peggy)
The grammar provided here is used for editing the rules, with suport of the "SBVR Assistant" tool in Business Rules Manager (BRM) tool of EUROCONTROL: [Peggy_BRM_editor](https://github.com/aixm/Business-Rules-Grammar/blob/main/Peggy_BRM_editor.pegjs).
This uses the library [Peggy](https://peggyjs.org/)

#### Tagging values
```<RuleName> = <name>:<RulePart> { <js_code using name> }```

Concrete example below, the NounConcept subrule will return the nounConcept, without its initial \$, surrounded by its tags. 

```NounConcept = "$" nc:(NounConceptChars+) { return `<noun_concept>${nc.join('')}</noun_concept>` }```

## Acknowledgements
Several people and organisations had a major contribution to the development and formalisation of the AIXM business rules grammar. In particular, the following contributions are acknowledged:
- Fadi SANDAKLY, IBM - under contract for Eurocontrol, 2022 - developed the initial EBNF version of the grammar after analysing the existing set of AIXM business rules
- Augustin LEDOYEN, Eiffage/Pulsar Consulting, 2023 - developed the initial Peggy version of the EBNF grammar, used for editing the rules
- Gregor KRAJCOVIC, Indra/Avitech, 2023 - proposed significant grammar refinements in order to facilitate the parsing of the rules
