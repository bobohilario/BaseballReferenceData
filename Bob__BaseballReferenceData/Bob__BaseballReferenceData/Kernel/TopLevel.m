
BeginPackage["Bob`BaseballReferenceData`"]

Bob`BaseballReferenceData`PlayerHomers
Bob`BaseballReferenceData`PlayerSearch
Bob`BaseballReferenceData`TeamPaths
Bob`BaseballReferenceData`TeamYearSchedule

Begin["`Private`"]

PlayerHomers[id_]:=brdata["PlayerHomers",{"id"->id}]
PlayerSearch[str_]:=brdata["PlayerSearch",{"search"->str}]
TeamPaths[]:=With[{ds=brdata["TeamList",{}]},
    ds[All,Append[#,"URL"->URL[URLBuild[{$BaseURL,#["Path"]}]]]&]
]

TeamYearSchedule[team_,year_,rest___]:=With[{t=toTeam[team]},
teamYearSchedule[
    brdata["TeamYearSchedule",<|"team"->t,"year"->ToString[year]|>],
    t,year,rest]
]

brdata[type_,params_]:=With[{raw=ImportBRXML[type,params]},
   Dataset@KeyUnion[GeneralUtilities`ToAssociations[ScrapeXML[type,raw]], Missing["NotAvailable"] &]
]


End[]

EndPackage[]