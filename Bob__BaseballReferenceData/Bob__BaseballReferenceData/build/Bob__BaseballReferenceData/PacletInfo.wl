(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "Bob__BaseballReferenceData",
    "Description" -> "Import data from baseball-reference.com",
    "Creator" -> "Bob Sandheinrich",
    "Version" -> "1.1.9",
    "WolframVersion" -> "12.2+",
    "Extensions" -> {
      {
        "Kernel",
        "Symbols" -> {
          "Bob`BaseballReferenceData`PlayerHomers",
          "Bob`BaseballReferenceData`PlayerSearch",
          "Bob`BaseballReferenceData`TeamPaths",
          "Bob`BaseballReferenceData`TeamYearSchedule"
        },
        "Root" -> "Kernel",
        "HiddenImport" -> True,
        "Context" -> {
          {
            "Bob`BaseballReferenceData`",
            "BaseballReferenceData.m"
          },
          {
            "Bob`BaseballReferenceData`Endpoints`",
            "Endpoints.m"
          },
          {
            "Bob`BaseballReferenceData`TopLevel`",
            "TopLevel.m"
          },
          {
            "Bob`BaseballReferenceData`XMLRules`",
            "XMLRules.m"
          },
          {
            "Bob`BaseballReferenceData`Teams`",
            "Teams.m"
          },
          {
            "Bob`BaseballReferenceData`Schedule`",
            "Schedule.m"
          }
        }
      },
      {"Documentation", "Root" -> "Documentation"}
    },
    "Loading" -> Automatic,
    "PublisherID" -> "Bob"
  |>
]
