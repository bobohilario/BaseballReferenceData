
BeginPackage["Testing`BaseballReferenceData`"]

Testing`BaseballReferenceData`PlayerHomers
Testing`BaseballReferenceData`PlayerSearch
Testing`BaseballReferenceData`TeamPaths

Begin["`Private`"]

PlayerHomers[id_]:=brdata["PlayerHomers",{"id"->id}]
PlayerSearch[str_]:=brdata["PlayerSearch",{"search"->str}]
TeamPaths[]:=With[{ds=brdata["TeamList",{}]},
    ds[All,Append[#,"URL"->URL[URLBuild[{$BaseURL,#["Path"]}]]]&]
]

brdata[type_,params_]:=With[{raw=ImportBRXML[type,params]},
   Dataset@KeyUnion[GeneralUtilities`ToAssociations[ScrapeXML[type,raw]], Missing["NotAvailable"] &]
]


End[]

EndPackage[]