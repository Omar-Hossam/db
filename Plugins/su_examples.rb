# Copyright 2013, Trimble Navigation Limited

# This software is provided as an example of using the Ruby interface
# to SketchUp.

# Permission to use, copy, modify, and distribute this software for 
# any purpose and without fee is hereby granted, provided that the above
# copyright notice appear in all copies.

# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#-----------------------------------------------------------------------------

# This extension includes a number of examples of how to use the Ruby interface
# to access a SketchUp model and perform various kinds of operations.

# The following line includes some common useful scripts.  The file
# sketchup.rb is automatically put in the SketchUp plugins directory
# when SketchUp is installed, so it should always get automatically
# loaded anyway, but it is good practice to explicitly require any
# files that you have dependencies on to make sure that they are loaded.
require 'sketchup.rb'
require 'extensions.rb'
require 'langhandler.rb'

module Sketchup::Examples

$exStrings = LanguageHandler.new("examples.strings")

examplesExtension = SketchupExtension.new(
  $exStrings.GetString("Ruby Script Examples"),
  "su_examples/exampleScripts.rb")

examplesExtension.description = $exStrings.GetString(
  "Adds examples of tools " +
  "created in Ruby to the SketchUp interface.  The example tools are " +
  "Draw->Box, Plugins->Cost and Camera->Animations.")
examplesExtension.version = "1.1.0"
examplesExtension.creator = "SketchUp"
examplesExtension.copyright = "2013, Trimble Navigation Limited"

Sketchup.register_extension examplesExtension, true

end # module Sketchup::Examples
