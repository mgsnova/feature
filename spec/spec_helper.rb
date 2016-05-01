require 'pathname'
require 'coveralls'
require 'fakeredis/rspec'

Coveralls.wear!
Coveralls::Output.silent = true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path

require SPEC_ROOT.parent + 'lib/feature'
require SPEC_ROOT + 'shared_examples/dynamic_repository_examples'
require SPEC_ROOT + 'shared_examples/repository_examples'
