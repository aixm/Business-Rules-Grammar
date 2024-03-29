AIXMBusinessRule = ItIsProhibited W_ ConditionsSeparated W_?
ConditionsSeparated = ElementaryCondition (W_ AndOr W_ ElementaryCondition)*

ElementaryCondition = (Not S_)? (VVV_NounValueVsNounValue / DVT_NounDescendNounsTest / DV_NounDescendNounsValue / D_NounDescendNouns / A_NounAncestor / RF_NounReferenceNoun / RFB_NounReferencedByNouns)

D_NounDescendNouns = p1:((Object / dataSet) S_) vc:("has-descendant"/"has") S_ p2:((QuantityOrRange S_)?) p3:(propertyPath) { return `${p1.join('')}<verb_concept>${vc}</verb_concept> ${p2?.join('') || ''}${p3}` } 

DVT_NounDescendNounsTest = D_NounDescendNouns S_ value S_ Test

D_NounDescendNounsNoQuantity = p1:((Object / dataSet) S_) vc:("has-descendant"/"has") S_ p3:propertyPath { return `${p1.join('')}<verb_concept>${vc}</verb_concept> ${''}${p3}` }

DV_NounDescendNounsValue = (D_NounDescendNounsNoQuantity S_ unspecified) / (D_NounDescendNouns S_ value)

VVV_NounValueVsNounValue = p1:((Object / dataSet) S_) vc:"has" p2:(S_ propertyPath S_ value S_ CompareValues S_ propertyPath S_ value) { return `${p1.join('')}<verb_concept>${vc}</verb_concept>${p2.join('')}` }

A_NounAncestor = p1:(Object S_) vc:"is-descendant-of" p2:(S_ (Object / dataSet)) { return `${p1.join('')}<verb_concept>${vc}</verb_concept>${p2.join('')}` }

RF_NounReferenceNoun = p1:(propertyWithRef S_) vc:"references-to" p2:(S_ Object) { return `${p1.join('')}<verb_concept>${vc}</verb_concept>${p2.join('')}` }

RFB_NounReferencedByNouns = p1:(Object S_) vc:"is-referenced-by" S_ p3:propertyWithRef { return `${p1.join('')}<verb_concept>${vc}</verb_concept> ${p3}` } 


Test = (That / CompareWithNumber / CompareWithSingleName / CompareWithNameArray / CoordinatesExpressedWith / ExpressedWith)

That = "#" W_? t:(CHAR / W_ / [-${}:,.+*/\\\[\]] /Integer)+ W_? "#" { return `#${t.join('')}#` }

CompareValues = compareValues:(higherOrEqual / higher / lowerOrEqual / lower / equal / different / sameAs / other) { return `<keyword>${compareValues}</keyword>` }

CompareWithNumber = operator:(higherOrEqual / higher / lowerOrEqual / lower / equal / different) S_ value:(parameter / (SingleQuote Decimal SingleQuote)) { return `<keyword>${operator}</keyword> <name>${value.join('')}</name>` }

CompareWithSingleName = operator:(sameAs / other / startingWith / containsSubstring) S_ value:((SingleQuote parameter SingleQuote) / Singlevalue) { return `<keyword>${operator}</keyword> <name>${value}</name>` }

CompareWithNameArray = operator:(otherThanAnyOf / asOneOf)  S_ value:(Multiplevalues / parameter) { return `<keyword>${operator}</keyword> <name>${value}</name>` }  

ExpressedWith = "expressed-with" S_ qr:(QuantityOrRange) S_ um:(Decimals / Characters) { return `<keyword>expressed-with</keyword> ${qr} <name>${um}</name>` }
CoordinatesExpressedWith = "coordinates-expressed-with" S_ qr:(QuantityOrRange) S_ um:(Decimals / Characters) { return `<keyword>coordinates-expressed-with</keyword> ${qr} <name>${um}</name>` }

Multiplevalues = "(" W_? sv:Singlevalue cv:(Commavalue)* W_? ")"  { return `(${sv}${cv.join('')})` }

Commavalue = W_? "," W_? v:Singlevalue { return `,${v}` }

Singlevalue = e:((SingleQuote valueContent SingleQuote) / (DoubleQuote valueContent DoubleQuote)) { return `${e.join('')}` }

Object = _$ obj:(Noun index?) { return `<noun_concept>${obj.join("")}</noun_concept>`}

propertyWithRef = _$ e:(elementPath) a:(hrefAttr) { return `<noun_concept>${e||""}${a}</noun_concept>`}

propertyPath 	= _$ p:(attrPath / elementPath) { return `<noun_concept>${p}</noun_concept>`}
attrPath 	= e:(elementPath)? a:(attr) { return `${e||""}${a}`}  

elementPath	= p1:(previousNoun)* p2:( Noun index?) p3:(nextNoun)* { return `${p1?.join("")}${p2.join("")}${p3?.join("")}` }
nextNoun = p1:(PS Noun) { return `${p1.join("")}` }
previousNoun = p1:(Noun PS) { return `${p1.join("")}` }

attr		= at:('@' namespace? NounChars) { return `${at.join('')}`}
Noun  		= nc:(namespace? (NounChars / parameter)) { return `${nc.join('')}`}
NounChars = p1:(CHAR) p2:([a-zA-Z_0-9]*) { return `${p1}${p2.join("")}` }

dataSet		= ds:("::dataSet") { return `<noun_concept>${ds}</noun_concept>`}
hrefAttr	= "@xlink:href"
namespace 	= p1:(CHAR) p2:([a-zA-Z_0-9]*) ':' { return `${p1}${p2.join('')}:`}
PS 			= '.'
index		= ix:('[' FirstDigit ']') { return `${ix.join('')}`}   

QuantityOrRange = (Quantity / Range)
Quantity = quantity:("more-than" / "exactly" / "less-than" / "at-least" / "at-most") S_ oneOrInteger:(OneOrInteger) { return `<keyword>${quantity} ${oneOrInteger}</keyword>` }
  
Range = "from" S_ n1:(MultipleIntegerNoZero) W_ "to" S_ n2:(MultipleIntegerNoZero) { return `<keyword>from ${n1} to ${n2}</keyword>` }
OneOrInteger = ("one" / MultipleIntegerNoZero / parameter)

parameter = "${" p:(CHAR)+ "}" { return `\$\{${p.join('')}\}` }

ItIsProhibited 	= prohibit:"It is prohibited that" { return `<keyword>${prohibit}</keyword>` }
AndOr 		= splitter:("and" / "or") { return `<keyword>${splitter}</keyword>` }
Not 		= not:"not" { return `<keyword>${not}</keyword>` }
Decimals	= "'decimals'"
Characters	= "'characters'" 
value 		= val:"value" { return `<keyword>${val}</keyword>` }
unspecified 	= val:"value unspecified" { return `<keyword>${val}</keyword>` }
higherOrEqual	= "higher-or-equal-to"
higher		= "higher-than"
lowerOrEqual	= "lower-or-equal-to"
lower		= "lower-than"
equal		= "equal-to"
different	= "different-from"
sameAs		= "as"
other		= "other-than"
startingWith 	= "starting-with"
containsSubstring = "contains-substring"
otherThanAnyOf 	= "other-than-one-of"
asOneOf		= "as-one-of"

valueContent 	= v:([!-&(-_a-z{-~ \t])+ { return `${v.join("")}` }  
 
MultipleInteger = int:Integer+ { return `<name>${int.join("")}</name>` }
MultipleIntegerNoZero = p1:(FirstDigit) p2:(Integer)* { return `${p1}${p2.join("")}` }
Decimal = int:(MultipleIntegerNoZero / Integer) dec:("." DecimalEnd)? { return `${int}${dec?.join("") || ""}` }
DecimalEnd = int:Integer+ { return `${int?.join("")}` }

CHAR = [a-zA-Z] 
Integer = [0-9]
FirstDigit = [1-9]
SingleQuote = [']
DoubleQuote = ["]
S_ = [ \t]+
W_ = (S_ / [\n\r])+
_$ = "$"
