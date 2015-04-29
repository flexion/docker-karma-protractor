docker-karma-protractor
=======================

Run karma (using PhantomJs, Chrome and Firefox) against a provided configuration file.

This karma running docker container requires that the app is build with [grunt](http://gruntjs.com/) and has been tested with a [Yeoman](http://yeoman.io/) created [AngularJS](https://angularjs.org/) project. To create an AngularJS project with yeoman `yo angular`.

If [protractor](https://angular.github.io/protractor) is added to the the grunt project it can also be used to do end-to-end tests.

To add protractor support to your project an easy way is to run `yo protractor` and merge the scaffolding to your AngularJS project.

# Configuration

## Environment variables

`BASE_URL` - url - For end-to-end test BASE_URL will be passed to protractor and override the configured baseUrl value in the protractor.conf.js file. If BASE_URL is not set it will be created from the linked web alias described below. When testing a web app that runs inside another docker container linking is the prefered way of doing it.

`RUN_NPM_INSTALL` - true/false - If true, `npm install` is run in the app's directory to install npm packages specified in the package.conf file. Default `false`.

`RUN_BOWER_INSTALL` - true/false - If true, `bower install` is run int he app'd directory to install bower components specified in the bower.json file. Default `true`.

`USER_ID` - number - Specifies number of the user id that the local karma user inside the docker container will get. The test will be run as this user. It should be set to the same user id as your normal user. Otherwise you will not have full access to files created by the container, such as reports and installed file from npm and bower. Your local user id can be fetch from `$(id -u)` or `$EUID`. Default value is `1000`.

`GROUP_ID` - number - Specifies the number of the user's effective group id. See `USER_ID` for details. Your local user id can be fetch from `$(id -g)` or `$EGID`. Default value is `1000`.

## Volumes

`/app` - Mount your app to this directory

## Links

`web` - The link alias `web` is used for connecting an your web application to this container when running the end-to-end test with protractor.  

## Commands

`karma` - Runs a standard karma test via grunt. This is the default command.

`protractor` - Runs protractor test via grunt. It requires that the web site to test is linked to the alias web, e.g. --link nginx:web

`no-bootstrap` - To enter the container as root user and before the app is initialized. Remember to use -it as parameter to docker. Used for debugging 

`<other command>` - will be run, as karma user, after the container and app is initialized. For example if you want to inspect what the container looks like just before the test starts you can specify `bash` as command. Don't forget to add `-it` as parameters to docker, otherwise you will not get a terminal.

Example usage:

	docker run -v $PWD:/app karma

	docker run -v $PWD:/app --link nginx:web protractor

	docker run -v $PWD:/app -e BASE_URL='http://angularjs.org' -e USER_ID=$EUID -e RUN_NPM_INSTALL=true protractor
