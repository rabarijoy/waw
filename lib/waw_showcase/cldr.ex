defmodule WawShowcase.Cldr do
  @moduledoc """
  Backend CLDR pour l'application WawShowcase.
  Nécessaire pour le fonctionnement des composants de date/heure comme `interval`.
  """
  use Cldr,
    locales: ["fr", "en"],
    default_locale: "fr",
    providers: [Cldr.Number, Cldr.DateTime, Cldr.Calendar]
end

