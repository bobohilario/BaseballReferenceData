(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "Testing/BaseballReferenceData",
    "Description" -> "Import data from baseball-reference.com",
    "Creator" -> "Bob Sandheinrich",
    "Version" -> "1.0.0",
    "WolframVersion" -> "12.2+",
    "Extensions" -> {
      {
        "Kernel",
        "Symbols" -> {
          "Testing`BaseballReferenceData`PlayerHomers",
          "Testing`BaseballReferenceData`PlayerSearch"
        },
        "Root" -> "Kernel",
        "HiddenImport" -> True,
        "Context" -> {
          {
            "Testing`BaseballReferenceData`",
            "BaseballReferenceData.m"
          },
          {
            "Testing`BaseballReferenceData`Endpoints`",
            "Endpoints.m"
          },
          {
            "Testing`BaseballReferenceData`TopLevel`",
            "TopLevel.m"
          },
          {
            "Testing`BaseballReferenceData`XMLRules`",
            "XMLRules.m"
          }
        }
      },
      {"Documentation", "Root" -> "Documentation"}
    },
    "Loading" -> Automatic,
    "PublisherID" -> "Testing"
  |>
]
