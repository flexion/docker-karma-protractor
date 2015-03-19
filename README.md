docker-karma
=============

Run karma (using Firefox) against a provided configuration file.

Example usage:

    docker run -v $PWD:/app -v $PWD/data/karma:/data muccg/karma:latest karma --log-level debug /app/path/to/karma.conf.js

