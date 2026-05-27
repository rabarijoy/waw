defmodule Waw.Cldr do
  use Cldr,
    default_locale: "fr",
    gettext: Waw.Gettext,
    locales: ["fr", "en"],
    providers: [
      Cldr.Number,
      Cldr.Unit,
      Cldr.List,
      Cldr.Calendar,
      Cldr.DateTime
    ]
end
