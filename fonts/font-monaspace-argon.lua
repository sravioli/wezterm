local wt = require "wezterm"

return function(config, _)
  config.font = wt.font_with_fallback {
    {
      family = "Monaspace Argon",
      weight = "Regular",
      harfbuzz_features = {
        -- "cv01", ---styles: a
        -- "cv02", ---styles: g
        "cv06", ---styles: i (03..06)
        -- "cv09", ---styles: l (07..10)
        "cv12", ---styles: 0 (11..13, zero)
        "cv14", ---styles: 3
        "cv16", ---styles: * (15..16)
        -- "cv17", ---styles: ~
        -- "cv18", ---styles: %
        -- "cv19", ---styles: <= (19..20
        -- "cv21", ---styles: =< (21..22)
        -- "cv23", ---styles: >=
        -- "cv24", ---styles: /=
        "cv25", ---styles: .-
        "cv26", ---styles: :-
        -- "cv27", ---styles: []
        "cv28", ---styles: {. .}
        "cv29", ---styles: { }
        -- "cv30", ---styles: |
        "cv31", ---styles: ()
        "cv32", ---styles: .=
        -- "ss01", ---styles: r
        -- "ss02", ---styles: <= >=
        "ss03", ---styles: &
        "ss04", ---styles: $
        "ss05", ---styles: @
        -- "ss06", ---styles: \\
        "ss07", ---styles: =~ !~
        -- "ss08", ---styles: == === != !==
        "ss09", ---styles: >>= <<= ||= |=
        -- "ss10", ---styles: Fl Tl fi fj fl ft
        -- "onum", ---styles: 1234567890
      },
    },
    { family = "Noto Color Emoji" },
    { family = "LegacyComputing" },
  }

  config.font_size = 12.0
  config.font_rules = {
    {
      intensity = "Normal",
      italic = true,
      font = wt.font("Monaspace Radon", { weight = "Regular" }),
    },
    {
      intensity = "Bold",
      italic = false,
      font = wt.font("Monaspace Neon", { weight = "ExtraBold" }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wt.font("Monaspace Radon", { weight = "ExtraBold" }),
    },
  }
end
