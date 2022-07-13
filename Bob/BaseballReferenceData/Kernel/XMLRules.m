
BeginPackage["Bob`BaseballReferenceData`"]

Bob`BaseballReferenceData`ScrapeXML

Begin["`Private`"]

ScrapeXML[type_,xml_]:=With[{rows=xmlRows[type,xml]},
    parseRows[type,rows]
]

xmlRows["BatterCareer",xml_]:=xml

xmlRows["PlayerStandardBatting",xml_]:=(
    Cases[xml,
        XMLElement[
        "tr", {"class" -> "full", 
            "id" -> _String?(StringStartsQ["batting_standard."])}, row_] :> 
        row, {5, 15}
    ]

)

xmlRows["PlayerHomers",xml_]:=Cases[xml,
   {XMLElement[
       "th", {___, "data-stat" -> "ranker", ___}, {tot_}],
      XMLElement[
       "td", {___, "data-stat" -> "career_num", ___}, {car_}],
      ___} , {5, Infinity}];


xmlRows["PlayerSearch",xml_]:=Cases[xml,
   XMLElement["div", {"class" -> "search-item"}, _] , {5, Infinity}];

xmlRows["TeamList",xml_]:=DeleteDuplicatesBy[
    DeleteDuplicatesBy[
        Cases[xml,
            XMLElement["a", {___, "href" -> ts:(_String?(StringMatchQ[#1, "/teams/*/"] &)), ___}, {name_}] :>
                <|
                "Path" -> ts, "Name" -> name
            |>, {1, Infinity}
        ],
        #["Name"]&
    ],
    #["Path"]&
]

xmlRows["TeamYearSchedule", xml_] :=
    Cases[xml, XMLElement["tr", {}, {XMLElement["th", {__, "data-stat"
         -> "team_game", ___}, {d_ /; StringMatchQ[d, DigitCharacter..]}], __
        }], Infinity]

parseRows[type_,rows_]:=With[{rules=XMLRules[type]},
    DeleteMissing[ResourceFunction["KeySortLike"][Association@parserow[type,rules,#],keyOrder[type]]&/@rows]
]

parserow["TeamList",_,row_]:=row

parserow[_,rules_,row_] := With[{data = Last @ Reap[Replace[row, rules, {1, Infinity}]]},
    Flatten[data] //. {str_String?(StringMatchQ[#, (DigitCharacter |
                "."
            )..
        ]&
        ) :> ToExpression[str], {elem_} :> elem, {} ->
            Missing[]
    }
]

keyOrder[_]:={}

XMLRules[All] = Join[
    XMLRules["PlayerHomers"]
]
XMLRules[_]={};

XMLRules["PlayerHomers"] = {XMLElement["th", {___, "data-stat" -> "ranker", ___}, {tot_}] :> Sow["Total" -> tot],
    XMLElement["td", {___, "data-stat" -> "career_num", ___}, {car_}]
         :> Sow["CareerCount" -> car],
    XMLElement["td", {___, "data-stat" -> "year_num", ___}, {yr_}] :>
         Sow["YearCount" -> yr],
    XMLElement["td", {___, "data-stat" -> "game_num", ___}, {gm_}] :>
         Sow["GameCount" -> gm],
    XMLElement["td", {___, "data-stat" -> "date_game", ___}, {
        XMLElement["a", {_, "href" -> boxlink_}, {date_}]}] :> Sow[{"Date" -> DateObject
         @ First[StringSplit[date, "("]], "BoxScoreURL" -> URL["https://www.baseball-reference.com"
         <> boxlink]}],
    XMLElement["td", {___, "data-stat" -> "batting_team_id", ___}, {tm_
        }] :> Sow["Team" -> tm],
    XMLElement["td", {___, "data-stat" -> "homeORvis", ___}, at_] :> 
        Sow["Location" -> (at /. {{"@"} -> "Away", {} -> "Home"})],
    XMLElement["td", {___, "data-stat" -> "pitching_team_id", ___}, {
        opp_}] :> Sow["Opponent" -> opp],
    XMLElement["td", {___, "data-stat" -> "pitcher", ___, "csk" -> pitchid_
        , ___}, {XMLElement["a", {_, "href" -> pitchlink_}, {pitchname_}]}] :>
         Sow[{"Pitcher" -> pitchname, "PitcherURL" -> URL["https://www.baseball-reference.com"
         <> pitchlink], "PitcherID" -> pitchid}],
    XMLElement["td", {___, "data-stat" -> "score_batting_team", ___},
         {sc1_}] :> Sow["Score" -> sc1],
    XMLElement["td", {___, "data-stat" -> "inning", ___}, {inn_}] :> 
        Sow["Inning" -> inn],
    XMLElement["td", {___, "data-stat" -> "outs", ___}, {outs_}] :> 
        Sow["Outs" -> outs],
    XMLElement["td", {___, "data-stat" -> "runners_on_bases_pbp", ___
        }, {onbase_}] :> Sow["OnBase" -> ToString[First[Flatten[{onbase, ""}]
        ], InputForm]],
    XMLElement["td", {___, "data-stat" -> "RBI", ___}, {rbis_}] :> 
        Sow["RBIs" -> rbis],
    XMLElement["td", {___, "data-stat" -> "batting_order_position", ___
        }, {order_}] :> Sow["BattingOrderPosition" -> order],
    XMLElement["td", {___, "data-stat" -> "pos_game", ___}, {pos_}] :>
         Sow["FieldingPosition" -> pos],
    XMLElement["td", {___, "data-stat" -> "wpa_bat", ___}, {wpa_}] :>
         Sow["WinProbAdded" -> wpa],
    XMLElement["td", {___, "data-stat" -> "win_expectancy_post_bat", 
        ___}, {winexp_}] :> Sow["WinExpectency" -> Interpreter["Percent"][winexp
        ]],
    XMLElement["td", {___, "data-stat" -> "hr_notes", ___}, {notes_}]
         :> Sow["Notes" -> notes],
    XMLElement["td", {___, "data-stat" -> "play_desc", ___}, {desc_}]
         :> Sow["Description" -> desc]
}

toKey["year_ID"]:="Year"
toKey["team_ID"]:="Team"
toKey["batting_avg"]="BA"
toKey["onbase_perc"]="OBP"
toKey["slugging_perc"]="SLG"
toKey["onbase_plus_slugging"]="OPS"
toKey["onbase_plus_slugging_plus"]="OPS+"

toKey[k_String]:=Capitalize[k]
toKey[expr_]:=expr

toRawValue[str_String]:=str
toRawValue[XMLElement[_, {}, {val_}]]:=toRawValue[val]
toRawValue[expr_]:=expr

XMLRules["PlayerStandardBatting"] = {
    XMLElement["td", {___, "data-stat" -> ("team_ID"), ___}, {XMLElement["a", KeyValuePattern[{
  "href"->path_}]
  , team_],___}] :>
         (Sow["Team" -> team];
         Sow["TeamURL" -> URL@URLDecode@URLBuild[{$BaseURL,path}]];
         ),
    XMLElement["td", {___, "data-stat" -> strkey:("pos_season"), ___}, {val_,___}] :>
         Sow[toKey[strkey] -> toRawValue@val],
    XMLElement["th", {___, "data-stat" ->(intkey:("year_ID")), ___}, {val_,___}] :>
         Sow[toKey[intkey] -> Interpreter["Integer",IntegerQ,Missing["NotAvailable"]][toRawValue@val]],
    XMLElement["td", {___, "data-stat" ->(intkey:("G"|"PA"|"year_ID"|"age"|"AB"|"R"|"H"|"2B"|"3B"|
        "HR"|"RBI"|"SB"|"CS"|"BB"|"SO"|"TB"|"GIDP"|"HBP"|"SH"|"SF"|"IBB")), ___}, {val_,___}] :>
         Sow[toKey[intkey] -> Interpreter["Integer",IntegerQ,Missing["NotAvailable"]][toRawValue@val]],
    XMLElement["td", {___, "data-stat" ->(realkey:("batting_avg"|"onbase_perc"|"slugging_perc"|"onbase_plus_slugging"|"onbase_plus_slugging_plus")), ___}, {val_,___}] :>
         Sow[toKey[realkey] -> Interpreter["Real",NumberQ,Missing["NotAvailable"]][toRawValue@val]]

}

keyOrder["PlayerStandardBatting"]={"Year","Team","Age",  "G", "PA", "AB", "R", "H", "2B", "3B", \
"HR", "RBI", "SB", "CS", "BB", "SO", "BA", "OBP", "SLG", \
"OPS", "OPS+", "TB", "GIDP", "HBP", "SH", "SF", "IBB", "Pos_season","TeamURL"};

XMLRules["PlayerSearch"] = {
    XMLElement["div", {"class" -> "search-item-url"}, {url_}] :> Sow[{"Path"->url,
    "URL" -> URL@URLDecode@URLBuild[{$BaseURL,url}],"ID"->pathToID[url]}],
    XMLElement["div", {"class" -> "search-item-name"}, {_,
        XMLElement["a", _, {namedates_}] |
            XMLElement[_, {___}, {XMLElement["a", _, {namedates_}]}],
                 __
        }
    ]
    :> Sow[With[{spl = StringTrim @ StringSplit[namedates, "\n"]},
        {"Name" -> First[spl, ""], "Dates" -> Last[spl, ""]}
    ], {0, Infinity
    }]
}


XMLRules["TeamYearSchedule"]={
    XMLElement["th", {___, "data-stat" -> "team_game", ___}, {val_}] :> Sow["GameNumber" -> val],
    XMLElement["td", {__,"data-stat" -> "date_game", ___}, 
        {XMLElement["a", {__, "href" -> scoreboardurl_,__}, {date_}]}]:>Sow[{"ScoreboardURL" -> URL["https://www.baseball-reference.com"
         <> scoreboardurl],"Date"->DateObject[date,"Day"]}],
    XMLElement["td", {__,"data-stat" -> "boxscore",___}, {XMLElement[
        "a", {___,"href" -> boxlink_,___}, {"boxscore"}]}]:>Sow[{"BoxScoreURL" -> URL["https://www.baseball-reference.com"
         <> boxlink]}],
    XMLElement["td", {__,"data-stat" -> "homeORvis",___}, {val_}]:>Sow[{"HomeGame" -> val=!="@"}],     
    XMLElement["td", {__,"data-stat" -> "opp_ID", ___}, 
        {XMLElement["a", {__, "href" -> oppurl_,___}, {val_}]}]:>Sow[{"OpponentURL" -> URL["https://www.baseball-reference.com"
         <> oppurl],"Opponent"->val}],
    XMLElement["td", {__,"data-stat" -> "opp_ID", ___}, {val_String}]:>Sow[{"Opponent"->val}],
    XMLElement["td", {__,"data-stat" -> "win_loss_result",___}, {val_}]:>Sow[{"Win" -> (val=!="L")}],  
    XMLElement["td", {__,"data-stat" -> "R",___}, {val_}]:>Sow[{"Runs" -> val}],  
    XMLElement["td", {__,"data-stat" -> "RA",___}, {val_}]:>Sow[{"RunsAllowed" -> val}],  
    XMLElement["td", {__,"data-stat" -> "extra_innings",___}, {val_}]:>Sow[{"ExtraInnings" -> val}],  
    XMLElement["td", {__,"data-stat" -> "win_loss_record",___}, {val_}]:>
        Sow[{"SeasonWins" -> First[StringSplit[val,"-"]],"SeasonLoses"->Last[StringSplit[val,"-"]]}],  
    XMLElement["td", {__,"data-stat" -> "rank",___}, {val_}]:>Sow[{"DivisionRank" -> val}],  
    XMLElement["td", {__,"data-stat" -> "games_back",___}, {val_}]:>Sow[{"DivisionGameBack" -> parseGamesBack[val]}],

    XMLElement["td", {__,"data-stat" -> "winning_pitcher",___}, {XMLElement[
        "a", {___,"href" -> pitcherurl_,"title" -> pitchername_}, {_}]}]:>
        Sow[{"WinningPitcherURL" -> URL["https://www.baseball-reference.com"
         <> pitcherurl],"WinningPitcher"->pitchername}],

    XMLElement["td", {__,"data-stat" -> "losing_pitcher",___}, {XMLElement[
        "a", {___,"href" -> pitcherurl_,"title" -> pitchername_}, {_}]}]:>
        Sow[{"LosingPitcherURL" -> URL["https://www.baseball-reference.com"
         <> pitcherurl],"LosingPitcher"->pitchername}],

    XMLElement["td", {__,"data-stat" -> "saving_pitcher",___}, {XMLElement[
        "a", {___,"href" -> pitcherurl_,"title" -> pitchername_}, {_}]}]:>
        Sow[{"SavingPitcherURL" -> URL["https://www.baseball-reference.com"
         <> pitcherurl],"SavingPitcher"->pitchername}],

    XMLElement["td", {__,"data-stat" ->"time_of_game",___}, {val_}]:>
        Sow[{"Duration" -> Total[DateValue[TimeObject[val], {"Hour", "Minute"}, Quantity]]}],  
    XMLElement["td", {__,"data-stat" -> "day_or_night",___}, {val_}]:>Sow[{"NightGame" -> val==="N"}],  
    XMLElement["td", {__,"data-stat" -> "attendance",___}, {val_}]:>Sow[{"Attendance" -> val}],  
    XMLElement["td", {__,"data-stat" -> "cli",___}, {val_}]:>Sow[{"ChampionshipLeverageIndex" -> val}],  
    XMLElement["td", {__,"data-stat" -> "win_loss_streak",___}, {XMLElement[__,{val_}]}]:>Sow[{"Streak" -> StringLength[val]}], 
    XMLElement["td", {__,"data-stat" -> "reschedule",___}, {val_}]:>Sow[{"Reschedule" -> val}]
    };

pathToID[str_]:=Lookup[URLParse[str]["Query"], "id"]/;StringStartsQ[str,"/register"]
pathToID[str_]:=FileBaseName[str]/;StringStartsQ[str,"/players"]
pathToID[_]:=Missing["Unknown"]

parseGamesBack["Tied"|" Tied"]=0.
parseGamesBack[up_String/;StringStartsQ[up,"up"]]:=-ToExpression[StringTrim[StringDelete[up,"up"]]]
parseGamesBack[str_String]:=StringTrim[str]
parseGamesBack[expr_]:=expr

End[]

EndPackage[]
