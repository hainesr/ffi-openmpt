# Ruby OpenMPT (ffi-openmpt)
## Robert Haines

### Synopsys

A ruby interface to `libopenmpt` - part of [OpenMPT][mpt-home].

See the [libopenmpt homepage][lib-home] for more information.

[![Gem Version](https://badge.fury.io/rb/ffi-openmpt.svg)](https://badge.fury.io/rb/ffi-openmpt)
[![Build Status](https://travis-ci.org/hainesr/ffi-openmpt.svg?branch=master)](https://travis-ci.org/hainesr/ffi-openmpt)
[![Tests](https://github.com/hainesr/ffi-openmpt/actions/workflows/test.yml/badge.svg)](https://github.com/hainesr/ffi-openmpt/actions/workflows/test.yml)
[![Linter](https://github.com/hainesr/ffi-openmpt/actions/workflows/lint.yml/badge.svg)](https://github.com/hainesr/ffi-openmpt/actions/workflows/lint.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/919bd8b421798dbd2719/maintainability)](https://codeclimate.com/github/hainesr/ffi-openmpt/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/hainesr/ffi-openmpt/badge.svg?branch=master)](https://coveralls.io/github/hainesr/ffi-openmpt)

### Prerequisits

#### libopenmpt

You must have `libopenmpt` installed. On Ubuntu this is done with:

```shell
$ sudo apt install libopenmpt0
```

You do not need the `libopenmpt` development libraries to be installed. If this library fails to find `libopenmpt` on your platform it might be due to it being named something slightly different. Please [raise an issue][issues] to let me know.

Instructions for installing `libopenmpt` from source are available on the [libopenmpt homepage][lib-home].

#### Ruby FFI

This library uses [Ruby FFI][ruby-ffi] (foreign function interface) to wrap the C API for `libopenmpt`. It will be installed automatically if you install this package via [Ruby Gems][rubygems], otherwise:

```shell
$ gem install ffi
```

will do the trick.

### Installation

Add `ffi-openmpt` to your `.gemspec` or `Gemfile` as appropriate, or install directly from [Ruby Gems][rubygems]:

```shell
$ gem install ffi-openmpt
```

### Usage

The library wraps the C `libopenmpt` API directly: methods have the same name and signature as their C counterparts. A more friendly ruby-like interface is also available, which hides the FFI details as much as possible.

Not all `libopenmpt` methods are wrapped yet, but enough functionality is supplied to load a module, interogate it and render it to a PCM stream.

#### A note on strings returned by `libopenmpt`

`libopenmpt` manages the memory of any strings it returns. This means that you must free up such memory explicitly after you have finished with them when using the C API. Such strings are returned to ruby as [`FFI::Pointer`][ffi-pointer] objects, so the string value can be copied to a ruby string as follows:

```ruby
begin
  ptr = FFI::OpenMPT::API.openmpt_get_string('url')
  str = ptr.read_string
ensure
  FFI::OpenMPT::API.openmpt_free_string(ptr)
end

puts str
```

The ruby interface handles all this for you:

```ruby
str = FFI::OpenMPT::String.get(:url)
puts str
```

### Example scripts

Scripts in the `examples` directory show how to use both the C and ruby APIs. You will need to make sure that `ffi-openmpt` is on your `RUBYLIB` path, or run the examples with `bundle exec`.

#### `mod-info` and `mod-info-api`

Display information about a mod file, for example:

```shell
$ ./mod-info lastsun.mod

Ruby OpenMPT (ffi-openmpt) file interrogator.
---------------------------------------------

Filename...: lastsun.mod
Size.......: 106k
Type.......: mod
Format.....: Generic Amiga / PC MOD file
Tracker....: Master Soundtracker 1.0
Title......: the last sun
Duration...: 3:56.4
Subsongs...: 1
Channels...: 4
Orders.....: 35
Patterns...: 20
Intruments.: 0
Samples....: 15
```

Both `mod-info` and `mod-info-api` output exactly the same data. `mod-info` uses the ruby interface, and `mod-info-api` uses the mapped `libopenmpt` C API directly.

#### `mod-2-raw`

Render a mod to a raw stereo PCM file. Use the `--float` switch to generate 32 bit float data, or omit for 16bit int data. For example:

```shell
$ ./mod-2-raw --float lastsun.mod

Ruby OpenMPT (ffi-openmpt) Mod to Raw PCM Converter.
----------------------------------------------------

Filename...: lastsun.mod
Size.......: 106k
Type.......: mod
Output type: float.raw
Output size: 88687k
```

The raw output format is simply a blob of `float` or `short` data. The left and right stereo channels are interleaved. The sample rate used is 48,000Hz.

### Library versions

Until this library reaches version 1.0.0 the API may be subject to breaking changes. When version 1.0.0 is released, then the principles of [semantic versioning][semver] will be applied.

### Licence

The Ruby OpenMPT code (ffi-openmpt) is released under the BSD licence.

Copyright (c) 2018-2021, Robert Haines
All rights reserved.

See LICENCE for more details.

### Acknowledgements

For testing purposes, this library uses and distributes ['The Last Sun'][lastsun] by Frederic Hahn. It is believed to be in the Public Domain, but if this is not the case please [raise an issue][issues] to let me know.

[ffi-pointer]: https://www.rubydoc.info/github/ffi/ffi/FFI/Pointer
[issues]: https://github.com/hainesr/ffi-openmpt/issues
[lastsun]: https://modarchive.org/module.php?47521
[lib-home]: https://lib.openmpt.org
[mpt-home]: https://openmpt.org/
[ruby-ffi]: https://rubygems.org/gems/ffi
[rubygems]: https://rubygems.org
[semver]: https://semver.org/
