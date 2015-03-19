docker-karma
=============

Run karma (using Firefox) against a provided configuration file.

Requires a bower.json file which contains the javascript deps for your tests.
These deps will be installed in /bower/ within the container.

Example usage:

    docker run -v $PWD:/app -v $PWD/data/karma:/data muccg/karma:latest karma /path/to/bower.json --log-level debug /app/path/to/karma.conf.js

