local sep = package.config:sub(1, 1)
package.path = ("plugins/chord.wz/plugin/?.lua;plugins/chord.wz/plugin/?/init.lua;"):gsub(
  "/",
  sep
) .. package.path
local wezterm = dofile(("plugins/chord.wz/spec/mocks/wezterm.lua"):gsub("/", sep))
local chord = require "chord.api"

describe("picker status integration", function()
  local saved, options, config, theme, renderer, handlers
  local modules = {
    "plugs.chord",
    "plugs.warp",
    "plugs.sigil",
    "opts",
    "opts.statusbar",
    "events.update-status",
    "utils.renderer",
    "utils.bar-budget",
  }

  before_each(function()
    saved = {}
    for _, name in ipairs(modules) do
      saved[name] = package.loaded[name]
      package.loaded[name] = nil
    end
    theme = {
      foreground = "#fff",
      background = "#000",
      ansi = { "#111", "#222", "#333", "#444", "#555", "#666" },
      brights = { "#888" },
      tab_bar = { background = "#000" },
    }
    config = { color_scheme = "test", color_schemes = { test = theme } }
    chord.tables(config, {
      normal_mode = {
        meta = { i = "M", txt = "NORMAL", bg = "#222" },
        keys = { { "a", "alpha", "alpha" } },
      },
    })
    wezterm.color = { parse = function() end }
    package.loaded["plugs.chord"] = chord
    package.loaded["plugs.warp"] = { filesystem = {}, maths = {} }
    package.loaded["plugs.sigil"] = {
      symbols = function()
        return { Sep = { ws = "", leader = "" } }
      end,
    }
    options = require "opts.statusbar"
    package.loaded.opts = { statusbar = options }
    renderer = {
      width = { available = 40, used = 8 },
      init = function() end,
      commit_left = function() end,
      render_layout = function()
        return "normal content"
      end,
    }
    package.loaded["utils.renderer"] = renderer
    package.loaded["utils.bar-budget"] = { set_count = function() end }
    handlers = {}
    wezterm.on = function(name, callback)
      handlers[name] = handlers[name] or {}
      table.insert(handlers[name], callback)
    end
    wezterm.emit = function(name, window, pane)
      for _, callback in ipairs(handlers[name] or {}) do
        callback(window, pane)
      end
    end
  end)

  after_each(function()
    for _, name in ipairs(modules) do
      package.loaded[name] = saved[name]
    end
  end)

  local function window(id, active)
    local pane = {
      pane_id = function()
        return id
      end,
    }
    return {
      active = active,
      window_id = function()
        return id
      end,
      active_pane = function()
        return pane
      end,
      active_key_table = function(self)
        return self.active
      end,
      effective_config = function()
        return config
      end,
      get_config_overrides = function()
        return {}
      end,
      mux_window = function()
        return {
          tabs = function()
            return { {} }
          end,
        }
      end,
      set_left_status = function(self, text)
        self.left = text
      end,
      set_right_status = function(self, text)
        self.right = text
      end,
    },
      pane
  end

  it(
    "renders temporary hints with the actual remaining budget and restores ordinary modes",
    function()
      local win, pane = window(201, "normal_mode")
      local normal =
        options.modules.keys(win, pane, theme, config).layout({ theme = theme }):format()
      assert.equal(32, #normal)
      assert.truthy(normal:find("a alpha", 1, true))
      assert.equal("NORMAL", options.modules.mode(win, pane, theme).text.value)
      win.active = "custom_picker"
      local release = chord.temporary.begin(win, pane, {
        name = "custom_picker",
        keys = {
          { "<C-x>", "dispatch", "custom action" },
          { "<ESC>", "cancel", "cancel" },
        },
        meta = function(t)
          return { i = "P", txt = "PICKER", bg = t.ansi[5] }
        end,
      })
      assert.equal("PICKER", options.modules.mode(win, pane, theme).text.value)
      for width = 0, 100 do
        renderer.width.available = width + renderer.width.used
        local hint =
          options.modules.keys(win, pane, theme, config).layout { theme = theme }
        assert.is_true(#hint:format() <= width)
      end
      release()
      assert.is_false(options.modules.keys(win, pane, theme, config).enabled)
      assert.is_false(options.modules.mode(win, pane, theme).enabled)
      win.active = "normal_mode"
      renderer.width.available = 40
      assert.equal(
        normal,
        options.modules.keys(win, pane, theme, config).layout({ theme = theme }):format()
      )
      assert.equal("NORMAL", options.modules.mode(win, pane, theme).text.value)
    end
  )

  it("refreshes on opening, paging and closing without accumulating handlers", function()
    require "events.update-status"
    require "events.update-status"
    assert.equal(1, #handlers["chord-temporary-changed"])
    assert.equal(1, #handlers["chord-hint-page-changed"])
    local win, pane = window(202, "picker")
    local updates = 0
    renderer.render_layout = function()
      updates = updates + 1
      return chord.temporary.get(win, theme) and "picker hints" or "normal content"
    end
    local release = chord.temporary.begin(win, pane, {
      name = "picker",
      keys = { { "a", "alpha", "alpha" } },
      meta = {},
    })
    assert.equal("picker hints", win.right)
    assert.equal(2, updates)
    chord.hint_action(nil, 1).callback(win, pane)
    assert.equal(4, updates)
    release()
    assert.equal(6, updates)
    assert.equal("normal content", win.right)
  end)

  it("respects disabled status bars independently in each window", function()
    require "events.update-status"
    options.enabled = false
    local a, pane = window(203, "picker")
    local b = window(204, "picker")
    renderer.init = function()
      error "disabled renderer must not run"
    end
    for _, win in ipairs { a, b } do
      local release = chord.temporary.begin(win, pane, {
        name = "picker",
        keys = {},
        meta = {},
      })
      assert.equal("", win.left)
      assert.equal("", win.right)
      assert.is_false(options.enabled)
      release()
    end
  end)
end)
