
BeginPackage["Bob`BaseballReferenceData`"]

Begin["`Private`"]

$CurrentTeams={"ANA", "ARI", "ATL", "BAL", "BOS", "LAD", "CHC", "CHW", "CIN", 
"CLE", "COL", "DET", "HOU", "OAK", "KCR", "FLA", "MIL", "MIN", "WSN", 
"SFG", "NYM", "NYY", "PHI", "PIT", "SDP", "SEA", "STL", "TBD", "TEX", 
"TOR", "LAD", "TBR", "LAA"};


teamRules={"Los Angeles Angels" | "LAA" | "Angels" -> "ANA", 
 "Arizona Diamondbacks" | "Arizona" | "Diamondbacks" -> "ARI", 
 "Atlanta Braves" | "Atlanta" | "Braves" -> "ATL", 
 "Baltimore Orioles" | "Baltimore" | "Orioles" -> "BAL", 
 "Boston Red Sox" | "Boston" | "Red Sox" -> "BOS", 
 "Los Angeles Dodgers" | "LAN" | "Dodgers" -> "LAD", 
 "Chicago Cubs" | "Chicago" | "Cubs" -> "CHC", 
 "Chicago White Sox" | "Chicago" | "White" | "Sox" -> "CHW", 
 "Cincinnati Reds" | "Cincinnati" | "Reds" -> "CIN", 
 "Cleveland Indians" | "Cleveland" | "Indians" -> "CLE", 
 "Colorado Rockies" | "Colorado" | "Rockies" -> "COL", 
 "Detroit Tigers" | "Detroit" | "Tigers" -> "DET", 
 "Houston Astros" | "Houston" | "Astros" -> "HOU", 
 "Oakland Athletics" | "Oakland" | "Athletics" -> "OAK", 
 "Kansas City Royals" | "Kansas City" | "Royals" -> "KCR", 
 "Miami Marlins" | "Miami" | "Marlins" -> "FLA", 
 "Milwaukee Brewers" | "Milwaukee" | "Brewers" -> "MIL", 
 "Minnesota Twins" | "Minnesota" | "Twins" -> "MIN", 
 "Washington Nationals" | "Washington" | "Nationals" -> "WSN", 
 "San Francisco Giants" | "San Francisco" | "Giants" -> "SFG", 
 "New York Mets" | "NYN" | "Mets" -> "NYM", 
 "New York Yankees" | "NYA" | "Yankees" -> "NYY", 
 "Philadelphia Phillies" | "Philadelphia" | "Phillies" -> "PHI", 
 "Pittsburgh Pirates" | "Pittsburgh" | "Pirates" -> "PIT", 
 "San Diego Padres" | "San Diego" | "Padres" -> "SDP", 
 "Seattle Mariners" | "Seattle" | "Mariners" -> "SEA", 
 "St. Louis Cardinals" | "St. Louis" | "St Louis" | "Saint Louis" | "Cardinals" -> "STL", 
 "Tampa Bay Rays" | "Tampa" | "Tampa Bay" | "Rays" |"Devil Rays" -> "TBD", 
 "Texas Rangers" | "Texas" | "Rangers" -> "TEX", 
 "Toronto Blue Jays" | "Toronto" | "Blue Jays" -> "TOR"}

toTeam[team:(Alternatives@@$CurrentTeams)]:=team

toTeam[team_String]:=team/.teamRules

End[]

EndPackage[]