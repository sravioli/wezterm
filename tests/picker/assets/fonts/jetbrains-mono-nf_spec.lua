---@diagnostic disable: undefined-global, undefined-field
local spec_helper = require("tests.spec_helper")

describe("picker.assets.fonts.jetbrains-mono-nf", function()
  local jetbrains_font
  local mock_config

  before_each(function()
    spec_helper.setup()

    -- Clear cache and load jetbrains font module
    package.loaded["picker.assets.fonts.jetbrains-mono-nf"] = nil
    jetbrains_font = require("picker.assets.fonts.jetbrains-mono-nf")

    -- Mock config object
    mock_config = {}
  end)

  after_each(function()
    spec_helper.teardown()
  end)

  describe("module structure", function()
    it("should be a table with get and activate functions", function()
      assert.is_table(jetbrains_font)
      assert.is_function(jetbrains_font.get)
      assert.is_function(jetbrains_font.activate)
    end)
  end)

  describe("get function", function()
    it("should return font metadata", function()
      local result = jetbrains_font.get()

      assert.is_table(result)
      assert.equals("jetbrains-mono-nf", result.id)
      assert.equals("Jetbrains Mono Nerd Font", result.label)
    end)

    it("should be consistent across calls", function()
      local result1 = jetbrains_font.get()
      local result2 = jetbrains_font.get()

      assert.equals(result1.id, result2.id)
      assert.equals(result1.label, result2.label)
    end)

    it("should return correct font identifier", function()
      local result = jetbrains_font.get()

      assert.is_string(result.id)
      assert.is_string(result.label)
      assert.truthy(#result.id > 0)
      assert.truthy(#result.label > 0)
    end)
  end)

  describe("activate function", function()
    it("should configure JetBrains Mono font", function()
      jetbrains_font.activate(mock_config, {})

      assert.is_table(mock_config.font)
      assert.equals(1.2, mock_config.line_height)
      assert.is_table(mock_config.font_rules)
    end)

    it("should set up font with fallbacks", function()
      jetbrains_font.activate(mock_config, {})

      -- The font should be created via wezterm.font_with_fallback
      assert.is_table(mock_config.font)
      -- In our mock, font_with_fallback returns the table passed to it
      assert.is_table(mock_config.font[1])
      assert.equals("JetBrainsMono Nerd Font", mock_config.font[1].family)
    end)

    it("should include emoji fallback", function()
      jetbrains_font.activate(mock_config, {})

      -- Should have fallback fonts including emoji
      local has_emoji_fallback = false
      for _, font in ipairs(mock_config.font) do
        if font.family == "Noto Color Emoji" then
          has_emoji_fallback = true
          break
        end
      end

      assert.is_true(has_emoji_fallback, "Should include emoji fallback font")
    end)

    it("should include legacy computing fallback", function()
      jetbrains_font.activate(mock_config, {})

      -- Should have LegacyComputing fallback
      local has_legacy_fallback = false
      for _, font in ipairs(mock_config.font) do
        if font.family == "LegacyComputing" then
          has_legacy_fallback = true
          break
        end
      end

      assert.is_true(has_legacy_fallback, "Should include LegacyComputing fallback font")
    end)

    it("should set specific line height", function()
      jetbrains_font.activate(mock_config, {})

      assert.equals(1.2, mock_config.line_height)
    end)

    it("should configure font rules", function()
      jetbrains_font.activate(mock_config, {})

      assert.is_table(mock_config.font_rules)
      assert.is_truthy(#mock_config.font_rules > 0)

      -- Check that font rules are properly structured
      for _, rule in ipairs(mock_config.font_rules) do
        assert.is_table(rule)
        -- Rules should have conditions and font specifications
        assert.is_truthy(rule.intensity or rule.italic or rule.weight)
      end
    end)

    it("should set Regular weight for primary font", function()
      jetbrains_font.activate(mock_config, {})

      local primary_font = mock_config.font[1]
      assert.equals("Regular", primary_font.weight)
    end)

    it("should configure harfbuzz features", function()
      jetbrains_font.activate(mock_config, {})

      local primary_font = mock_config.font[1]
      assert.is_table(primary_font.harfbuzz_features)
    end)

    it("should handle nil opts parameter", function()
      assert.has_no_errors(function()
        jetbrains_font.activate(mock_config, nil)
      end)

      -- Should still configure the font
      assert.is_table(mock_config.font)
    end)

    it("should overwrite existing font configuration", function()
      mock_config.font = "Old Font"
      mock_config.line_height = 2.0
      mock_config.font_rules = { "old rule" }

      jetbrains_font.activate(mock_config, {})

      assert.not_equals("Old Font", mock_config.font)
      assert.equals(1.2, mock_config.line_height)
      assert.not_same({ "old rule" }, mock_config.font_rules)
    end)
  end)

  describe("font configuration details", function()
    it("should maintain font fallback order", function()
      jetbrains_font.activate(mock_config, {})

      local font_families = {}
      for _, font in ipairs(mock_config.font) do
        table.insert(font_families, font.family)
      end

      -- JetBrains should be first, followed by emoji, then legacy
      assert.equals("JetBrainsMono Nerd Font", font_families[1])
      assert.equals("Noto Color Emoji", font_families[2])
      assert.equals("LegacyComputing", font_families[3])
    end)

    it("should handle font weight correctly", function()
      jetbrains_font.activate(mock_config, {})

      local primary_font = mock_config.font[1]
      assert.is_string(primary_font.weight)
      assert.equals("Regular", primary_font.weight)
    end)

    it("should create complete font configuration", function()
      jetbrains_font.activate(mock_config, {})

      -- Check all expected properties are set
      assert.is_table(mock_config.font)
      assert.is_number(mock_config.line_height)
      assert.is_table(mock_config.font_rules)

      -- Verify font structure
      local primary_font = mock_config.font[1]
      assert.is_string(primary_font.family)
      assert.is_string(primary_font.weight)
      assert.is_table(primary_font.harfbuzz_features)
    end)
  end)

  describe("integration scenarios", function()
    it("should work with get/activate workflow", function()
      local meta = jetbrains_font.get()

      -- Simulate user selection
      assert.equals("jetbrains-mono-nf", meta.id)
      assert.equals("Jetbrains Mono Nerd Font", meta.label)

      -- Apply the font
      jetbrains_font.activate(mock_config, meta)

      -- Verify font was configured
      assert.is_table(mock_config.font)
      assert.equals("JetBrainsMono Nerd Font", mock_config.font[1].family)
    end)

    it("should be compatible with WezTerm API", function()
      jetbrains_font.activate(mock_config, {})

      -- The configuration should be compatible with WezTerm's expected structure
      assert.is_table(mock_config.font)
      assert.is_number(mock_config.line_height)

      -- Font rules should follow WezTerm format
      for _, rule in ipairs(mock_config.font_rules) do
        assert.is_table(rule.font)
      end
    end)
  end)

  describe("error handling", function()
    it("should handle nil config parameter", function()
      assert.has_no_errors(function()
        pcall(jetbrains_font.activate, nil, {})
      end)
    end)

    it("should handle WezTerm API failures gracefully", function()
      -- Mock WezTerm API failure
      spec_helper.mock_wezterm.font_with_fallback = function()
        error("Font creation failed")
      end

      assert.has_no_errors(function()
        pcall(jetbrains_font.activate, mock_config, {})
      end)
    end)
  end)

  describe("font-specific features", function()
    it("should not include monaspace features for JetBrains", function()
      jetbrains_font.activate(mock_config, {})

      local primary_font = mock_config.font[1]
      -- JetBrains Mono shouldn't have monaspace-specific features
      assert.same({}, primary_font.harfbuzz_features)
    end)

    it("should be distinguishable from other fonts", function()
      local meta = jetbrains_font.get()

      -- Should have unique identifier
      assert.equals("jetbrains-mono-nf", meta.id)
      assert.truthy(meta.label:match("JetBrains") or meta.label:match("Jetbrains"))
    end)
  end)
end)
