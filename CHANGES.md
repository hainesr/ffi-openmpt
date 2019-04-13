# Changes log for the Ruby OpenMPT library (ffi-openmpt)

## Version 0.4.0

* Update the minimum ruby version to 2.3.
* Update to use bundler 2.0.1.
* Update the string example in README.md.
* Simplify the API string code example.
* Add sample_name to the ruby interface.
* Align info method names with the C++ API.
* Ensure memory is always freed in String::get.
* Ensure memory is always freed in Module methods.
* Ensure memory is always freed in OpenMPT methods.
* Update the memory handling code example in the README.
* Use `warn` not `puts` for error messages in mod-2-raw.
* Fix wording of an error message in mod-2-raw.
* Add Module#sample_names to the ruby interface.
* Add a note in Module::new about MemoryPointer.
* Remove Module#sample_name. It's not in the C++ API.
* Generalize getting name lists from a mod.
* Add Module#instrument_names to the ruby interface.
* Add Module#pattern_names to the ruby interface.
* Add Module#order_names to the ruby interface.
* Add Module#channel_names to the ruby interface.
* Add Module#subsong_names to the ruby interface.

## Version 0.3.0

* Wrap the libopenmpt module read mono functions.
* Add mono read (short/float) calls to the ruby interface.
* Move the string get method to its own namespace.
* Allow getting informational strings directly.
* Wrap Module#metadata_keys.
* Directly query module metadata keys.
* Update test version of libopenmpt to 0.3.13.
* Parameterize the test libopenmpt version.
* Update Travis config to use latest rubies.
* Turn on `fast_finish` in the Travis config.
* Switch to use latest dist (Xenial) in Travis.
* Test multiple versions of the libopenmpt library.
* Wrap libopenmpt module repeat functions.
* Add repeat_count to the ruby interface.
* Wrap libopenmpt module positional calls.
* Add positional calls to the ruby interface.

## Version 0.2.0

* Add a Gem version badge to the README.md.
* Wrap the libopenmpt module probing functions.
* Enforce comparisons, not predicates, for older rubies.
* Wrap libopenmpt informational function: get subsongs.
* Wrap libopenmpt informational function: get channels.
* Wrap libopenmpt informational function: get orders.
* Wrap libopenmpt informational function: get patterns.
* Wrap libopenmpt informational function: get instruments.
* Wrap libopenmpt informational function: get samples.
* Wrap libopenmpt informational function: subsong names.
* Wrap libopenmpt informational function: channel names.
* Wrap libopenmpt informational function: order names.
* Wrap libopenmpt informational function: pattern names.
* Wrap libopenmpt informational function: instrument names.
* Wrap libopenmpt informational function: sample names.
* Wrap libopenmpt render parameter functions.
* Add an example script to read mod information.
* Document the mod-info example in the README.
* Use File.binread to load module data in the example.
* Rename the example script to show that it uses the API.
* Start ruby-like interface to a mod: Module.
* Add the metadata method to the ruby interface.
* Add duration to the ruby interface.
* Add the simple informational calls to the ruby interface.
* Replicate the 'mod-info' example with the ruby interface.
* Add notion of a closed mod to the ruby interface.
* Catch a closed mod and return in the ruby interface.
* Allow access to the metadata via ruby interface methods.
* Use the new metadata method mappings in mod-info.
* Update README with details of the second example script.
* Add the get_string library call to the ruby interface.
* Add the extensions library call to the ruby interface.
* Add the supported_extension? library call to the ruby interface.
* Move the module probe function to the OpenMPT namespace.
* Get render param 'gain' in the ruby interface.
* Set render param 'gain' in the ruby interface.
* Get render param 'stereo_separation' in the ruby interface.
* Set render param 'stereo_separation' in the ruby interface.
* Get render param 'interpolation_filter' in the ruby interface.
* Set render param 'interpolation_filter' in the ruby interface.
* Get render param 'volume_ramping' in the ruby interface.
* Set render param 'volume_ramping' in the ruby interface.
* Add transient_error? call to the ruby interface.
* Add error_string call to the ruby interface.
* Change supported_extensions to return list of Symbols.
* Add sample_rate instance variable to Module.
* Add missing tests for a closed module.
* Add stereo read (short) calls to the ruby interface.
* Add stereo read (float) calls to the ruby interface.
* Add a 'mod-2-raw' ruby interface example script.
* Add a note to the README about finding libopenmpt.
* Update the README with information about the ruby interface.

## Version 0.1.0

* Add Code of Conduct.
* Add Travis configuration.
* Add a Travis badge to the README.
* Set up Coveralls integration.
* Add a Coveralls badge to the README.
* Add a CodeClimate badge to the README.
* Add rubocop configuration files.
* Add rubocop tasks to the Rakefile.
* Many rubocop fixes.
* Add ffi as a dependency.
* Wrap the libopenmpt version methods.
* Wrap the libopenmpt logging callbacks.
* Add tests for the API module.
* Test the logging API functions.
* Wrap the libopenmpt error callbacks.
* Wrap libopenmpt module create/destroy functions.
* Add a helper method to test against mod files.
* Wrap the libopenmpt module duration function.
* Wrap the libopenmpt module read stereo functions.
* Test the module_read functions against real data.
* Add libopenmpt to the Travis config.
* Switch to old Travis architecture to install dependencies.
* Install libopenmpt manually on Travis.
* Wrap the libopenmpt module read interleaved stereo functions.
* Wrap the libopenmpt string functions.
* Wrap the libopenmpt extension querying functions.
* Wrap the libopenmpt informational error functions.
* Wrap the libopenmpt module error functions.
* Wrap the libopenmpt module metadata functions.

## About this file

This file is, at least in part, generated by the following command:

```shell
$ git log --pretty=format:"* %s" --reverse --no-merges <commit-hash>..
```
