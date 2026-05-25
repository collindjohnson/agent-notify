#!/usr/bin/env node
'use strict';

require('../lib/npm/launcher').runCli('agent-notify', process.argv.slice(2));
