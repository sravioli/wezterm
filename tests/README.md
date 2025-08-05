# WezTerm Configuration Tests

This directory contains comprehensive L0 tests for the WezTerm configuration using the Busted testing framework.

## Test Structure

The test suite mirrors the project structure and includes:

### Core Utilities (`utils/`)
- **`fn_spec.lua`** - Tests for utility functions including table operations, string manipulation, and color utilities
- **`init_spec.lua`** - Tests for the utils module loader with lazy loading and metatable behavior
- **`perf_spec.lua`** - Tests for performance utilities including timing, memory tracking, and profiling
- **`gpu_spec.lua`** - Tests for GPU adapter detection and configuration
- **`class/config_spec.lua`** - Tests for the Config class including initialization, module addition, and chaining
- **`class/logger_spec.lua`** - Tests for the Logger class including log levels, formatting, and error handling  
- **`class/picker_spec.lua`** - Tests for the Picker class including selection, filtering, and window integration
- **`class/icon_spec.lua`** - Tests for icon management including separators and powerline symbols
- **`class/layout_spec.lua`** - Tests for layout management including pane operations and responsive design
- **`external/inspect_spec.lua`** - Tests for the inspect library including complex data structures and formatting

### Configuration Modules (`config/`)
- **`init_spec.lua`** - Tests for configuration module merging and structure validation
- **`appearance_spec.lua`** - Tests for appearance configuration including colors, cursor, and theme integration
- **`font_spec.lua`** - Tests for font configuration including metrics, rules, and platform compatibility
- **`tab-bar_spec.lua`** - Tests for tab bar configuration including appearance, colors, and accessibility
- **`general_spec.lua`** - Tests for general WezTerm settings and workspace configuration
- **`gpu_spec.lua`** - Tests for GPU-specific configuration and performance settings

### Event Handlers (`events/`)
- **`format-tab-title_spec.lua`** - Tests for tab title formatting including colors, caching, and edge cases
- **`update-status_spec.lua`** - Tests for status bar updates including workspace, key tables, and leader keys
- **`format-window-title_spec.lua`** - Tests for window title formatting and context display
- **`new-tab-button-click_spec.lua`** - Tests for new tab button interaction handling
- **`augment-command-palette_spec.lua`** - Tests for command palette enhancement with picker integration

### Key Mappings (`mappings/`)
- **`init_spec.lua`** - Tests for key binding merging and WezTerm compatibility
- **`default_spec.lua`** - Tests for default key bindings and standard shortcuts
- **`modes_spec.lua`** - Tests for modal key bindings including resize and copy modes

### Pickers (`picker/`)
- **`colorscheme_spec.lua`** - Tests for colorscheme picker including discovery, selection, and preview
- **`font_spec.lua`** - Tests for font picker including comparison functions and fuzzy search
- **`font-size_spec.lua`** - Tests for font size picker including numeric sorting and reset functionality
- **`font-leading_spec.lua`** - Tests for font leading picker including line height configuration

### Picker Assets (`picker/assets/`)
- **`font-leadings/font-leadings_spec.lua`** - Tests for font leading value generation and activation
- **`font-sizes/font-sizes_spec.lua`** - Tests for font size value generation and configuration integration
- **`fonts/reset_spec.lua`** - Tests for font reset functionality and configuration restoration
- **`fonts/jetbrains-mono-nf_spec.lua`** - Tests for specific font configuration including fallbacks and features

### Integration Tests (`integration/`)
- **`picker_workflow_spec.lua`** - Tests for cross-picker workflows and interaction patterns
- **`configuration_system_spec.lua`** - Tests for complete configuration loading and module integration

### Stress Tests (`stress/`)
- **`system_resilience_spec.lua`** - Tests for system behavior under load, memory pressure, and error conditions

### Main Configuration
- **`wezterm_spec.lua`** - Tests for the main configuration entry point

## Test Framework

### Helper Module (`spec_helper.lua`)
Provides common utilities for all tests:
- Mock WezTerm module with realistic API
- Test data factories for tabs, windows, and panes  
- Assertion helpers for validation
- Setup and teardown functions

### Test Runner (`run_tests.lua`)
Comprehensive test runner with:
- Sequential test suite execution
- Environment validation
- Performance testing
- Memory usage monitoring
- Detailed reporting

## Running Tests

### Prerequisites
```bash
# Install Busted testing framework
luarocks install busted
```

### Basic Test Execution
```bash
# Run all tests
lua tests/run_tests.lua

# Run with performance tests
lua tests/run_tests.lua --performance

# Run with memory checking
lua tests/run_tests.lua --memory
```

### Individual Test Suites
```bash
# Run specific test file using busted
busted tests/utils/fn_spec.lua
busted tests/config/appearance_spec.lua
```

### Using Busted Directly
```bash
# Run all tests in tests directory
busted tests/

# Run with verbose output
busted --verbose tests/

# Run with coverage (if lua-cov available)
busted --coverage tests/
```

## Test Categories

### L0 (Unit Tests)
All tests in this suite are L0 unit tests that:
- Test individual functions and methods in isolation
- Use mocks for external dependencies
- Validate input/output behavior
- Check error handling and edge cases
- Ensure type safety and validation

### Coverage Areas

#### Functional Testing
- ✅ Configuration loading and merging
- ✅ Event handler registration and execution
- ✅ Key binding processing
- ✅ Color scheme management
- ✅ Window and pane interactions

#### Error Handling
- ✅ Missing modules and files
- ✅ Malformed configuration data
- ✅ Invalid input parameters
- ✅ Runtime errors and exceptions
- ✅ Resource constraints

#### Performance
- ✅ Configuration loading speed
- ✅ Event handler efficiency  
- ✅ Memory usage patterns
- ✅ Rapid interaction handling
- ✅ Large dataset processing

#### Integration
- ✅ WezTerm API compatibility
- ✅ Module interdependencies
- ✅ Configuration precedence
- ✅ Event system integration
- ✅ Picker window integration

## Test Patterns

### Mock Usage
```lua
-- Example of mocking WezTerm API
helper.mock_wezterm.on("event", function(...)
  -- Mock event handler
end)
```

### Assertion Patterns
```lua
-- Custom assertions for common patterns
helper.assert_table_contains(config, "key")
helper.assert_function_exists(object, "method")
helper.assert_valid_color("#ffffff")
```

### Error Testing
```lua
-- Testing error conditions
assert.has_no.errors(function()
  -- Code that should not error
end)

assert.has_errors(function()
  -- Code that should error
end)
```

## Continuous Integration

The test suite is designed for CI/CD integration:
- Exit codes indicate success/failure
- Detailed error reporting
- Performance benchmarking
- Memory leak detection

## Extending Tests

When adding new features:

1. **Create corresponding test file** following naming convention `*_spec.lua`
2. **Add to test runner** in `run_tests.lua` test_suites array
3. **Follow existing patterns** for setup, mocking, and assertions
4. **Include error cases** and edge conditions
5. **Test integration points** with existing modules

## Test Data

Test files use realistic data that mirrors actual WezTerm usage:
- Valid color schemes and themes
- Realistic key binding configurations  
- Proper window and pane structures
- Common user interaction patterns

This ensures tests validate real-world usage scenarios while maintaining isolation and repeatability.

