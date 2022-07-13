
BeginPackage["Bob`BaseballReferenceData`"]

Bob`BaseballReferenceData`$BaseURL
Bob`BaseballReferenceData`Endpoint
Bob`BaseballReferenceData`ImportBRXML

Begin["`Private`"]

$BaseURL="https://www.baseball-reference.com/";

Endpoint[name_,params___]:=URLBuild[{$BaseURL,endpointPath[name,params]}]

endpointPath["PlayerStandardBatting",id_String]:=URLBuild[{"players",StringTake[id,1],id<>".shtml"}]<>"#batting_standard"
endpointPath["PlayerHomers",___]="players/event_hr.fcgi"
endpointPath["BatterCareer",id_String]:=URLBuild[{"players",StringTake[id,1],id}]
endpointPath["TeamList",___]="teams"
endpointPath["PlayerSearch",___]="search/search.fcgi"
endpointPath["TeamYearSchedule",___]="teams/`team`/`year`-schedule-scores.shtml"

ImportBRXML[name_,params_]:=Quiet[Import[URLBuild[TemplateApply[URLDecode@Endpoint[name,params],params],Cases[
    params,_Rule]], "XMLObject"],
    $CharacterEncoding::utf8]

End[]

EndPackage[]