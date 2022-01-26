
BeginPackage["Testing`BaseballReferenceData`"]

Testing`BaseballReferenceData`$BaseURL
Testing`BaseballReferenceData`Endpoint
Testing`BaseballReferenceData`ImportBRXML

Begin["`Private`"]

$BaseURL="https://www.baseball-reference.com/";

Endpoint[name_]:=URLBuild[{$BaseURL,endpointPath[name]}]

endpointPath["PlayerHomers"]="players/event_hr.fcgi"
endpointPath["TeamList"]="teams"
endpointPath["PlayerSearch"]="search/search.fcgi"

ImportBRXML[name_,params_]:=Quiet[Import[URLBuild[Endpoint[name],params], "XMLObject"],$CharacterEncoding::utf8]

End[]

EndPackage[]