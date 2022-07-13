
BeginPackage["BaseballReferenceData`"]

BaseballReferenceData`ScrapeXML

Begin["`Private`"]

ScrapeXML[type_,xml_]:=With[{rows=xmlRows[type,xml]},
    parseRows[type,rows]
]

xmlRows["BatterCareer",xml_]:=(Global`$xml=xml)

xmlRows["PlayerHomers",xml_]:=Cases[xml,
   {XMLElement[
       "th", {___, "data-stat" -> "ranker", ___}, {tot_}],
      XMLElement[
       "td", {___, "data-stat" -> "career_num", ___}, {car_}],
      ___} , {5, Infinity}];


xmlRows["PlayerSearch",xml_]:=Cases[xml,
   XMLElement["div", {"class" -> "search-item"}, _] , {5, Infinity}];

xmlRows["TeamList",xml_]:=DeleteDuplicates[
    Cases[xml,
        XMLElement["a", {___, "href" -> ts:(_String?(StringMatchQ[#1, "/teams/*/"] &)), ___}, {name_}] :>
             <|
            "Path" -> ts, "Name" -> name
        |>, {1, Infinity}
    ]
]

parseRows[type_,rows_]:=With[{rules=XMLRules[type]},
    parserow[type,rules,#]&/@rows
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

XMLRules[All] = Join[
    XMLRules["PlayerHomers"]
]
XMLRules["TeamList"]={};

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

pathToID[str_]:=Lookup[URLParse[str]["Query"], "id"]/;StringStartsQ[str,"/register"]
pathToID[str_]:=FileBaseName[str]/;StringStartsQ[str,"/players"]
pathToID[str_]:=Missing["Unknown"]

End[]

EndPackage[]
