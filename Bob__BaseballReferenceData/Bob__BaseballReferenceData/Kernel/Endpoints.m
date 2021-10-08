
BeginPackage["Bob`BaseballReferenceData`"]

Bob`BaseballReferenceData`$BaseURL
Bob`BaseballReferenceData`Endpoint
Bob`BaseballReferenceData`ImportBRXML

Begin["`Private`"]

$BaseURL="https://www.baseball-reference.com/";

Endpoint[name_]:=URLBuild[{$BaseURL,endpointPath[name]}]

endpointPath["PlayerHomers"]="players/event_hr.fcgi"
endpointPath["TeamList"]="teams"
endpointPath["PlayerSearch"]="search/search.fcgi"
endpointPath["TeamYearSchedule"]="teams/`team`/`year`-schedule-scores.shtml"

ImportBRXML[name_,params_]:=Quiet[Import[URLBuild[TemplateApply[URLDecode@Endpoint[name],params],params], "XMLObject"],
    $CharacterEncoding::utf8]

End[]

EndPackage[]