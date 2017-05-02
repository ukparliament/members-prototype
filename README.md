# Parliament.uk prototype
[Parliament.uk Prototype][parliament.uk-prototype] is a [Rails][rails] application designed to be the beginnings of a new [parliament.uk][parliament] website and API.

[![Build][shield-build]][info-build] [![Gemnasium][shield-dependencies]][info-dependencies] [![License][shield-license]][info-license]

### Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Application architecture](#application-architecture)
    - [Parliamentary Data API](#parliamentary-data-api)
    - [Bandiera](#bandiera)
    - [Parliament Rails Application](#parliament-rails-application)
  - [Running the application](#running-the-application)
  - [Running the tests](#running-the-tests)
    - [Running them within the running application image](#running-them-within-the-running-application-image)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Requirements
[Parliament.uk Prototype][parliament.uk-prototype] requires the following:
* [Ruby][ruby] - for the exact version, [click here][ruby-version].
* [Docker][docker]


## Getting Started
Clone the repository:
```bash
git clone https://github.com/ukparliament/parliament.uk-prototype.git
cd parliament.uk-prototype
```

### Application architecture
[Parliament.uk Prototype][parliament.uk-prototype] is made up of three main components:

* Parliamentary Data API
* [Bandiera][bandiera]
* [Parliament.uk Prototype][parliament.uk-prototype] Rails Application

There are a number of additional side pieces but for now, these are our main focus.

#### Parliamentary Data API
Behind the prototype is an API that provides our application with all the data it needs to run. This data is served in an [RDF][rdf] format called [n-triples][n-triples].

In production, there is an API application that serves dynamic data to our Rails application. For local development, we use the [parliament.uk-static-api][parliament.uk-static-api] application/docker image.

Using the static application allows us to quickly prototype data responses without a reliance on the internal parliament API.

#### Bandiera
['Bandiera is a simple, stand-alone feature flagging service'][bandiera] which we use to enable and disable certain features within the parliament application.

We use Bandiera to enable and disable time-boxed states such as [dissolution][dissolution] within the application. When enabled, banners display on certain pages of the site.

#### Parliament Rails Application
This is the [Parliament.uk Prototype][parliament.uk-prototype] application itself, the routes, controllers and views that make up our application.


### Running the application
Running the application locally is done using docker-compose, but there is a one-off set up command needed the first time:
```bash
make dev
```

This command will set up the dependent docker images and databases that the application uses to run.

Once this step has been completed, you can simply run:
```bash
docker-compose up
```

Now the three main applications should be available as follows:
 * Prototype Rails Application - [http://localhost:3000](http://localhost:3000)
 * Static API - [http://localhost:3030](http://localhost:3030)
 * Bandiera - [http://localhost:5000](http://localhost:5000)


### Running the tests
We use [RSpec][rspec] as our testing framework, and run our tests inside of Docker. Use the below command to run the full suite.
```bash
make test
```

#### Running them within the running application image
The downside to running `make test` is speed, virtually every time, we will be rebuilding the Docker image just to run our tests.

To get around this, whilst developing we can first connect to the running application and run tests within it. The following commands assume you have the application running via `docker-compose up`:
```bash
docker-compose exec app /bin/sh
bundle exec rspec
```

This will first open an sh terminal within the running application server, then execute the tests right away without the need to re-build the image.


## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License
[Parliament.uk Prototype][parliament.uk-prototype] is licensed under the [Open Parliament Licence][info-license].

[rails]:                    http://rubyonrails.org
[parliament]:               http://www.parliament.uk
[ruby]:                     https://www.ruby-lang.org/en/
[docker]:                   https://www.docker.com
[rspec]:                    http://rspec.info
[parliament.uk-prototype]:  https://github.com/ukparliament/parliament.uk-prototype
[ruby-version]:             https://github.com/ukparliament/parliament.uk-prototype/blob/master/.ruby-version
[bandiera]:                 https://github.com/springernature/bandiera
[rdf]:                      https://en.wikipedia.org/wiki/Resource_Description_Framework
[n-triples]:                https://en.wikipedia.org/wiki/N-Triples
[parliament.uk-static-api]: https://github.com/ukparliament/parliament.uk-static-api
[dissolution]:              http://www.parliament.uk/about/how/elections-and-voting/general/dissolution/

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg

[info-build]:   https://travis-ci.org/ukparliament/parliament.uk-prototype
[shield-build]: https://img.shields.io/travis/ukparliament/parliament.uk-prototype.svg

[info-dependencies]:   https://gemnasium.com/github.com/ukparliament/parliament.uk-prototype
[shield-dependencies]: https://img.shields.io/gemnasium/ukparliament/parliament.uk-prototype.svg
