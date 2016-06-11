## 1.4.0 (2016-06-11)

* possibility to refresh feature list after certain time (enc)
* call to get all active features (pmeskers)
* Improve and prettify README (glaucocustodio)
* Fixing typos in README (adarsh)

## 1.3.0 (2015-06-12)

* Support testing with multiple features (stevenwilkin)
* Bugfix when using auto_refresh and testing support (javidjamae)
* Fixing an issue with Feature.run_with_activated if @active_features is nil (tommyh)

## 1.2.0 (2014-10-28)

* add Support for auto-refresh of feature data (javidjamae)
* read list of features at first usage instead of initialization (lazy-load)
* add RedisRepository (javidjamae)
* remove explicit Rails 3 Support of ActiveRecordRepository

## 1.1.0 (2014-09-30)

* generator compatible with Rails 3/4 (mumoshu)
* add LICENSE (pivotalfish)
* add optional environment flag for YamlRepository (cherbst-medidata)
* documentation fixes (asmega, crackofdusk)
* update to rspec 3

## 1.0.0 (2014-03-26)

* drop ruby 1.8 support
* support Rails 4 generator loading only (mauriciovieira)
* add Feature.switch method (FlavourSys)
* minor code and doc fixes and cleanup

## 0.7.0 (2013-12-07)

* add ActiveRecordRepository and a Rails::Generator (bigzed)

## 0.6.0 (2013-03-24)

* add capability for easier testing of activated or deactivated features

## 0.5.0 (2012-09-29)

* added erb support for yaml feature config (dscataglini)
* fixed travis integration
* added code climate link

## 0.4.1 (2012-03-20)

* bugfix: occured when having empty feature set using yaml config (benjaminoakes)

## 0.4.0 (2011-11-28)

* simplify repositories, they only have to respond to method active_features 

## 0.3.0 (2011-11-23)

* assume all features as inactive that are not active, also unknown ones
* make yaml parsing in yaml repository more strict

## 0.2.1 (2011-11-22)

* refactored gemspec

## 0.2.0 (2011-11-22)

* add yaml config file repository

## 0.1.0 (2011-11-18)

* first version with basic functionality and simple feature repository
