# Members Prototype
Members prototype is a [Rails 5][rails] application designed to be the beginnings of a new [parliament.uk][parliament] website and api.

[![License][shield-license]][info-license]


### Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Requirements](#requirements)
- [Getting Started](#getting-started)
  - [Running the application](#running-the-application)
    - [Member Service API?](#member-service-api)
    - [Running with Foreman and a Local Version of the API](#running-with-foreman-and-a-local-version-of-the-api)
      - [Foreman?](#foreman)
    - [Running the application standalone, without an API](#running-the-application-standalone-without-an-api)
  - [Running the tests](#running-the-tests)
- [Contributing](#contributing)
- [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Requirements
Members prototype requires the following:
* [Ruby 2.3.1][ruby]  
* [Node][node]
* [NPM][npm]


## Getting Started
Setup the main application repository:
```bash
git clone https://github.com/ukparliament/members-prototype.git
cd members-prototype
bundle install
cp .env.sample .env
```

### Running the application
There are two options for running the members prototype, either with a local version of the member api at the same time, or as a standalone rails application.

#### Member Service API?
Along with this prototype there is a paired [member-service-api][member-service-api] project. This api's role is to consume data from a triple store and generate .ttl files which our members-prototype can consume.

#### Running with Foreman and a Local Version of the API
> **NOTE:** In order to use [foreman][foreman] to run the api and application together, we are assuming you have the [member-service-api][member-service-api] project cloned and set-up in the same location as the members-prototype project. For example, your folders should look something like the following:
> ```
> /                       (projects root)
> /members-prototype/     (prototype)
> /member-service-api/    (api)
> ```
> With this setup, foreman runs the api directly from within the member-service-api directory.

```bash
bundle exec foreman start
```

The application and api should now be viewable in your local browser at http://localhost:3000 (application) and http://localhost:3030 (api). With this setup, you can make changes to the local api repository and test them right away.

##### Foreman?
[Foreman][foreman] allows us to run multiple applications concurrently, making local development of the members prototype much faster. Using foreman you can make changes to both the member-api and prototype in tandem without the need for deployment delays.


#### Running the application standalone, without an API
> **NOTE:** In order to run the application without a local copy of the [member-service-api][member-service-api], you'll need to update your `.env` file to include remote `API_ENDPOINT` and `API_ENDPOINT_HOST` values. The included sample assumes you are running the API locally with foreman.

```bash
bundle exec rails s
```

The application should now be viewable in your local browser at: http://localhost:3000.


### Running the tests
We use [RSpec][rspec] as our testing framework and tests can be run using:
```bash
bundle exec rspec
```


## Contributing
If you wish to submit a bug fix or feature, you can create a pull request and it will be merged pending a code review.

1. Fork the repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## License
[Members Prototype][members-prototype] is licensed under the [Open Parliament Licence][info-license].

[rails]:              http://rubyonrails.org
[parliament]:         http://www.parliament.uk
[ruby]:               https://www.ruby-lang.org/en/
[node]:               https://nodejs.org/en/
[npm]:                https://www.npmjs.com
[member-service-api]: https://github.com/ukparliament/member-service-api
[foreman]:            https://github.com/ddollar/foreman
[rspec]:              http://rspec.info
[members-prototype]:  https://github.com/ukparliament/members-prototype

[info-license]:   http://www.parliament.uk/site-information/copyright/open-parliament-licence/
[shield-license]: https://img.shields.io/badge/license-Open%20Parliament%20Licence-blue.svg
