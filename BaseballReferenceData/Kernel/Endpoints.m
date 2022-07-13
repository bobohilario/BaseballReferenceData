
BeginPackage["BaseballReferenceData`"]

BaseballReferenceData`$BaseURL
BaseballReferenceData`Endpoint
BaseballReferenceData`ImportBRXML

Begin["`Private`"]

$BaseURL="https://www.baseball-reference.com/";

Endpoint[name_, params___]:=URLBuild[{$BaseURL,endpointPath[name,params]}]

endpointPath["PlayerHomers",___]="players/event_hr.fcgi"
endpointPath["BatterCareer",id_String]:=URLBuild[{"players",StringTake[id,1],id}]
endpointPath["TeamList",___]="teams"
endpointPath["PlayerSearch",___]="players"


ImportBRXML[name_,params_]:=Quiet[Import[URLBuild[Endpoint[name],params], "XMLObject"],$CharacterEncoding::utf8]

End[]

EndPackage[]