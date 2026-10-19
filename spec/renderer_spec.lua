local function visible_width(value)
  value = tostring(value or ""):gsub("\27%[[\32-\63]*[\64-\126]", "")
  local width = 0
  for codepoint in value:gmatch "[^\128-\191][\128-\191]*" do
    width = width + (codepoint == "中" and 2 or 1)
  end
  return width
end

local Ribbon = {}
Ribbon.__index = Ribbon

function Ribbon.new()
  return setmetatable({ items = {} }, Ribbon)
end

function Ribbon:clear()
  self.items = {}
  return self
end

function Ribbon:append(_, _, text)
  self.items[#self.items + 1] = text or ""
  return self
end

function Ribbon:format()
  return table.concat(self.items)
end

describe("status-bar renderer", function()
  local module_names = {
    "opts",
    "utils.renderer",
    "utils.bar-budget",
    "plugs.ribbon",
    "plugs.warp",
    "plugs.log",
    "wezterm",
  }
  local saved, opts, renderer, window, pane, config, theme

  before_each(function()
    saved = {}
    for _, name in ipairs(module_names) do
      saved[name] = package.loaded[name]
      package.loaded[name] = nil
    end

    package.loaded.wezterm = {
      column_width = visible_width,
      format = function(items)
        local output = {}
        for _, item in ipairs(items) do
          if type(item) == "string" then
            output[#output + 1] = item
          elseif item.Text then
            output[#output + 1] = item.Text
          end
        end
        return table.concat(output)
      end,
    }
    package.loaded["plugs.ribbon"] = {
      new = function()
        return Ribbon.new()
      end,
    }
    package.loaded["plugs.warp"] = {
      string = {
        width = visible_width,
        pad = function(value, padding)
          value = tostring(value or "")
          local left, right
          if type(padding) == "table" then
            left, right = padding.left or 0, padding.right or 0
          else
            left, right = padding or 1, padding or 1
          end
          return string.rep(" ", left) .. value .. string.rep(" ", right)
        end,
      },
      table = {
        merge = function(_, ...)
          local result = {}
          for i = 1, select("#", ...) do
            for key, value in pairs(select(i, ...)) do
              result[key] = value
            end
          end
          return result
        end,
      },
    }
    package.loaded["plugs.log"] = {
      new = function()
        return { debug = function() end, warn = function() end }
      end,
    }
    package.loaded["utils.bar-budget"] = {
      set_screen_width = function() end,
      set_tab_max_width = function() end,
      set_left_used = function() end,
      set_new_tab_button = function() end,
      right_available = function()
        return 120
      end,
    }

    opts = { flexible = true, fit = "exhaustive", modules = {} }
    package.loaded.opts = { statusbar = opts }
    renderer = require "utils.renderer"
    window = {
      get_dimensions = function()
        return { pixel_width = 120 }
      end,
    }
    pane = {
      get_dimensions = function()
        return { cols = 120, pixel_width = 120 }
      end,
    }
    config = { tab_max_width = 30 }
    theme = { foreground = "#fff", background = "#000" }
  end)

  after_each(function()
    for _, name in ipairs(module_names) do
      package.loaded[name] = saved[name]
    end
  end)

  local function make_module(icon, text, options)
    options = options or {}
    return {
      enabled = true,
      cond = true,
      can_hide = options.can_hide ~= false,
      priority = options.priority or 0,
      padding = options.padding or 0,
      icon = { enabled = true, value = icon, padding = 0 },
      text = {
        enabled = true,
        value = text,
        padding = 0,
        variants = options.variants,
        trim = options.trim,
      },
    }
  end

  local function render(names, width, fit)
    opts.fit = fit or "exhaustive"
    pane.get_dimensions = function()
      return { cols = width, pixel_width = 120 }
    end
    renderer.init(config, window, pane, theme)
    return renderer.render_layout({ names })
  end

  it("uses the full candidate when every module fits", function()
    opts.modules.first = make_module("A", "alpha")
    opts.modules.second = make_module("B", "bravo")

    assert.equal("AalphaBbravo", render({ "first", "second" }, 40))
  end)

  it("keeps exhaustive layouts within the available width", function()
    opts.modules.first = make_module("A", "alpha", {
      variants = { "al", "a" },
    })
    opts.modules.second = make_module("B", "bravo", {
      variants = { "br", "b" },
    })
    opts.modules.third = make_module("C", "charlie", {
      variants = { "ch", "c" },
    })

    for width = 0, 30 do
      local result = render({ "first", "second", "third" }, width)
      assert.is_true(visible_width(result) <= width, "width " .. width)
    end
  end)

  it("truncates long Unicode text by display columns", function()
    opts.modules.unicode = make_module("", string.rep("中", 8))

    local result = render({ "unicode" }, 5)
    assert.equal("中中…", result)
    assert.equal(5, visible_width(result))
  end)

  it("keeps the balanced hide and grow result inside its budget", function()
    opts.modules.first = make_module("A", "alpha", { priority = 3 })
    opts.modules.second = make_module("B", "bravo", { priority = 2 })
    opts.modules.third = make_module("C", "charlie", { priority = 1 })

    for width = 0, 12 do
      local result = render({ "first", "second", "third" }, width, "balanced")
      assert.is_true(visible_width(result) <= width, "width " .. width)
    end
  end)
end)
