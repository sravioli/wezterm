---Unit tests for WezTerm DevIcons
local devicons = require("utils.devicons")

-- Test framework
local tests = {}
local passed = 0
local failed = 0

local function assert_equal(actual, expected, message)
  if actual == expected then
    passed = passed + 1
    print("✅ " .. (message or "Test passed"))
  else
    failed = failed + 1
    print("❌ " .. (message or "Test failed") .. string.format(": expected '%s', got '%s'", expected, actual))
  end
end

local function assert_not_nil(value, message)
  if value ~= nil then
    passed = passed + 1
    print("✅ " .. (message or "Test passed"))
  else
    failed = failed + 1
    print("❌ " .. (message or "Test failed") .. ": value was nil")
  end
end

-- Initialize devicons for testing
devicons.setup({
  strict = true,
  override = {
    ["test_file"] = {
      icon = "🧪",
      color = "#FF0000",
      name = "TestFile"
    }
  }
})

print("=== Running WezTerm DevIcons Tests ===\n")

-- Test 1: Basic icon retrieval
local icon, color, name = devicons.get_icon("README.md")
assert_not_nil(icon, "README.md should have an icon")
assert_not_nil(color, "README.md should have a color")
assert_equal(name, "README", "README.md should be identified as README")

-- Test 2: Extension-based matching
icon, color, name = devicons.get_icon("script.js")
assert_not_nil(icon, "JavaScript files should have an icon")
assert_equal(name, "Js", "JavaScript files should be identified as 'Js'")

-- Test 3: TypeScript React
icon, color, name = devicons.get_icon("Component.tsx")
assert_equal(name, "Tsx", "TypeScript React files should be identified as 'Tsx'")

-- Test 4: Python files
icon, color, name = devicons.get_icon("main.py")
assert_equal(name, "Python", "Python files should be identified as 'Python'")

-- Test 5: Lua files
icon, color, name = devicons.get_icon("config.lua")
assert_equal(name, "Lua", "Lua files should be identified as 'Lua'")

-- Test 6: C# files
icon, color, name = devicons.get_icon("Program.cs")
assert_equal(name, "Cs", "C# files should be identified as 'Cs'")

-- Test 7: XAML files
icon, color, name = devicons.get_icon("MainWindow.xaml")
assert_equal(name, "Xaml", "XAML files should be identified as 'Xaml'")

-- Test 8: Unknown file with default
icon, color, name = devicons.get_icon("unknown.xyz", nil, { default = true })
assert_not_nil(icon, "Unknown files should get default icon when requested")
assert_equal(name, "Default", "Unknown files should be identified as 'Default'")

-- Test 9: Unknown file without default
icon, color, name = devicons.get_icon("unknown.xyz", nil, { default = false })
assert_equal(icon, "", "Unknown files should get empty icon when default=false")

-- Test 10: Filename-based matching
icon, color, name = devicons.get_icon("package.json")
assert_equal(name, "PackageJson", "package.json should be identified as 'PackageJson'")

-- Test 11: Dockerfile
icon, color, name = devicons.get_icon("Dockerfile")
assert_equal(name, "Dockerfile", "Dockerfile should be identified as 'Dockerfile'")

-- Test 12: Git ignore
icon, color, name = devicons.get_icon(".gitignore")
assert_equal(name, "GitIgnore", ".gitignore should be identified as 'GitIgnore'")

-- Test 13: Custom override
icon, color, name = devicons.get_icon("test_file")
assert_equal(icon, "🧪", "Custom override should work")
assert_equal(color, "#FF0000", "Custom override color should work")
assert_equal(name, "TestFile", "Custom override name should work")

-- Test 14: Extension API
local extensions = devicons.get_icons_by_extension()
assert_not_nil(extensions["js"], "Extensions should include 'js'")
assert_not_nil(extensions["py"], "Extensions should include 'py'")
assert_not_nil(extensions["lua"], "Extensions should include 'lua'")

-- Test 15: Filename API
local filenames = devicons.get_icons_by_filename()
assert_not_nil(filenames["package.json"], "Filenames should include 'package.json'")
assert_not_nil(filenames["Dockerfile"], "Filenames should include 'Dockerfile'")
assert_not_nil(filenames[".gitignore"], "Filenames should include '.gitignore'")

-- Test 16: All icons API
local all_icons = devicons.get_icons()
local count = 0
for _ in pairs(all_icons) do
  count = count + 1
end
assert_not_nil(all_icons, "get_icons() should return a table")
print(string.format("ℹ️  Total icons available: %d", count))

-- Test 17: cterm color API
icon, cterm_color, name = devicons.get_icon_cterm_color("script.js")
assert_not_nil(cterm_color, "cterm color should be available for JavaScript")

-- Test 18: Setup validation
assert_equal(devicons.has_loaded(), true, "DevIcons should be marked as loaded")

-- Test 19: Refresh functionality (should not error)
devicons.refresh()
assert_equal(devicons.has_loaded(), true, "DevIcons should still be loaded after refresh")

-- Test 20: Set custom icon
devicons.set_icon("custom_ext", {
  icon = "🔧",
  color = "#00FF00",
  name = "CustomExt"
})
icon, color, name = devicons.get_icon("test.custom_ext")
assert_equal(name, "CustomExt", "Custom icon should be settable")

print(string.format("\n=== Test Results ==="))
print(string.format("✅ Passed: %d", passed))
print(string.format("❌ Failed: %d", failed))
print(string.format("📊 Total:  %d", passed + failed))

if failed == 0 then
  print("\n🎉 All tests passed! WezTerm DevIcons is working correctly.")
else
  print(string.format("\n⚠️  %d test(s) failed. Please check the implementation.", failed))
end

return {
  passed = passed,
  failed = failed,
  success = failed == 0
}
