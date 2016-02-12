#!/usr/bin/env node

/**
 * This example script expects a JSON blob generated by react-docgen as input,
 * e.g. react-docgen components/* | buildDocs.sh
 */

var fs = require('fs');
var generateMarkdown = require('./generateMarkdown.sh');
var path = require('path');

var json = '';
process.stdin.setEncoding('utf8');
process.stdin.on('readable', function() {
  var chunk = process.stdin.read();
  if (chunk !== null) {
    json += chunk;
  }
});

process.stdin.on('end', function() {
  buildDocs(JSON.parse(json));
});

function buildDocs(api) {
  // api is an object keyed by filepath. We use the file name as component name.
  for (var filepath in api) {
    var name = getComponentName(filepath);
    var markdown = generateMarkdown(name, api[filepath]);
    var outputLocation = 'docs/api/';
    fs.writeFileSync(outputLocation + name + '.md', markdown);
    process.stdout.write(filepath + ' -> ' + outputLocation + name + '.md\n');
  }
}

function getComponentName(filepath) {
  var name = path.basename(filepath);
  var ext;
  while ((ext = path.extname(name))) {
    name = name.substring(0, name.length - ext.length);
  }
  return name;
}
