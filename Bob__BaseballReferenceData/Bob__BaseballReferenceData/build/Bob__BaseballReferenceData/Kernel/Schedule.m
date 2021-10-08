
BeginPackage["Bob`BaseballReferenceData`"]

Begin["`Private`"]


teamYearSchedule[data_,team_,year_,"LongestWinStreak"]:=data[Split/*Cases[{True ..}], "Win"][Max, Length]
teamYearSchedule[data_,team_,year_,"LongestLossStreak"]:=data[Split/*Cases[{True ..}], "Loss"][Max, Length]
teamYearSchedule[data_,___]:=data

End[]

EndPackage[]