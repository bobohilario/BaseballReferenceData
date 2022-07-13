(* ::Package:: *)

PacletObject[
  <|
    "Name" -> "Testing/BaseballReferenceData",
    "Description" -> "Import data from baseball-reference.com",
    "Creator" -> "Bob Sandheinrich",
    "License" -> "MIT",
    "PublisherID" -> "Testing",
    "Version" -> "1.1.0",
    "WolframVersion" -> "13.0+",
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
    "Loading" -> Automatic
  |>
]
