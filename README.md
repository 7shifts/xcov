<h3 align="center">
<img src="/assets_readme/logo.png" alt="xcov Logo" />
</h3>

-------

[![Twitter: @carlostify](https://img.shields.io/badge/contact-@carlostify-blue.svg?style=flat)](https://twitter.com/carlostify)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/nakiostudio/xcov/blob/master/LICENSE)
[![Gem](https://img.shields.io/gem/v/xcov.svg?style=flat)](http://rubygems.org/gems/xcov)
[![Gem Downloads](https://img.shields.io/gem/dt/xcov.svg?style=flat)](http://rubygems.org/gems/xcov)

**xcov** is a friendly visualizer for Xcode's code coverage files.

## Installation
```
sudo gem install xcov
```

## Features
* Built on top of [fastlane](https://fastlane.tools), you can easily plug it on to your CI environment.
* Blacklisting of those files which coverage you want to ignore.
* Minimum acceptable coverage percentage.
* Compatible with [Coveralls](https://coveralls.io).
* Nice HTML reports.

<h3 align="center">
<img src="/assets_readme/report.png" />
</h3>

* Slack integration.

<h3 align="center">
<img src="/assets_readme/slack_integration.png" />
</h3>

## Requirements
In order to make *xcov* run you must:
* Use Xcode 7.
* Have the latest version of Xcode command line tools.
* Set your project scheme as **shared**.
* Enable the **Gather coverage data** setting available on your scheme settings window.

<h3 align="center">
<img src="/assets_readme/gather_coverage.png" />
</h3>

## Usage
*xcov* analyzes the `.xccoverage` files created after running your tests therefore, before executing xcov, you need to run your tests with either `Xcode`, `xcodebuild` or [scan](https://github.com/fastlane/fastlane/tree/master/scan). Once completed, obtain your coverage report by providing a few parameters:
```
xcov -w LystSDK.xcworkspace -s LystSDK -o xcov_output
```

### Parameters allowed
* `--workspace` `-w`: Path of your `xcworkspace` file.
* `--project` `-p`: Path of your `xcodeproj` file (optional).
* `--scheme` `-s`: Scheme of the project to analyze.
* `--configuration` `-q`: The configuration used when building the app. Defaults to 'Release' (optional).
* `--output_directory` `-o`: Path for the output folder where the report files will be saved.
* `--source_directory` `-r`: The path to project's root directory (optional).
* `--derived_data_path` `-j`: Path of your project `Derived Data` folder (optional).
* `--minimum_coverage_percentage` `-m`: Raise exception if overall coverage percentage is under this value (ie. 75.0).
* `--include_test_targets`: Enables coverage reports for `.xctest` targets.
* `--ignore_file_path` `-x`: Relative or absolute path to the file containing the list of ignored files.
* `--exclude_targets`: Comma separated list of targets to exclude from coverage report.
* `--include_targets`: Comma separated list of targets to include in coverage report.
* `--slack_url` `-i`: Incoming WebHook for your Slack group to post results (optional).
* `--slack_channel` `-e`: Slack channel where the results will be posted (optional).
* `--html_report`: Enables the creation of a html report. Enabled by default (optional).
* `--json_report`: Enables the creation of a json report (optional).
* `--markdown_report`: Enables the creation of a markdown report (optional).
* `--skip_slack`: Add this flag to avoid publishing results on Slack (optional).
* `--only_project_targets`: Display the coverage only for main project targets (e.g. skip Pods targets).
* `--coveralls_service_name`: Name of the CI service compatible with Coveralls. i.e. travis-ci. This option must be defined along with coveralls_service_job_id (optional).
* `--coveralls_service_job_id`: Name of the current job running on a CI service compatible with Coveralls. This option must be defined along with coveralls_service_name (optional).
* `--coveralls_repo_token`: Repository token to be used by integrations not compatible with Coveralls (optional).
* `--slack_username`: The username which is used to publish to slack (optional).
* `--slack_message`: The message which is published together with a successful report (optional).

_**Note:** All paths you provide should be absolute and unescaped_

### Ignoring files
You can easily ignore the coverage for a specified set of files by adding their filenames to the *ignore file* specified with the `--ignore_file_path` parameter (this file is `.xcovignore` by default). You can also specify a wildcard expression for matching a group of files.

If you want to ignore all the files from a directory (folder), specify directory's relative path in *ignore file*. Also, specify `source_directory` if that differs from working directory (which is the default value).

Each one of the filenames you would like to ignore must be prefixed by the dash symbol `-`. In addition you can comment lines by prefixing them by `#`. Example:

```yaml
# Api files
- LSTSessionApi.swift
- LSTComponentsApi.swift
- LSTNotificationsApi.swift

# Managers
- LSTRequestManager.m
- LSTCookiesManager.m

# Utils
- LSTStateMachine.swift

# Exclude all files ending by "View.swift"
- .*View.swift

# Exclude all dependencies
- Pods
- Carthage/Checkouts
```

**Note:** Ignores are handled case-insensitively. `Pods` will match any of `pods`, `PODS`, or `Pods`.

## [Fastlane](https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Actions.md)

*Fastlane 1.61.0* includes *xcov* as a custom action. You can easily create your coverage reports as follows:
```ruby
xcov(
  workspace: "YourWorkspace.xcworkspace",
  scheme: "YourScheme",
  output_directory: "xcov_output"
)  
```

## [Danger](https://danger.systems)

With the *Danger* plugin you can receive your coverage reports directly on your pull requests. You can find more information on the plugin repository available [here](https://github.com/nakiostudio/danger-xcov).

<h3 align="center">
<img src="/assets_readme/xcov_danger.png" />
</h3>

## [Coveralls](https://coveralls.io)

If you want to keep track of the coverage evolution and get some extra features, *xcov* allows you to submit coverage reports to *Coveralls*. To do so, simply create an account and run *xcov* setting the options `coveralls_service_name` and `coveralls_service_job_id` for compatible CI environments. However, if you want to post to *Coveralls* from the console or any custom environment simply set the `coveralls_repo_token` option.

<h3 align="center">
<img src="/assets_readme/coveralls_integration.png" />
</h3>

## Contributors

[![nakiostudio](https://avatars2.githubusercontent.com/u/1814571?v=3&s=50)](https://github.com/nakiostudio)
[![opfeffer](https://avatars3.githubusercontent.com/u/1138127?v=3&s=50)](https://github.com/opfeffer)
[![stevenreinisch](https://avatars0.githubusercontent.com/u/675216?v=3&s=50)](https://github.com/stevenreinisch)
[![hds](https://avatars0.githubusercontent.com/u/89589?v=3&s=50)](https://github.com/hds)
[![michaelharro](https://avatars3.githubusercontent.com/u/318260?v=3&s=50)](https://github.com/michaelharro)
[![thelvis4](https://avatars1.githubusercontent.com/u/1589385?v=3&s=50)](https://github.com/thelvis4)
[![KrauseFx](https://avatars1.githubusercontent.com/u/869950?v=3&s=50)](https://github.com/KrauseFx)
[![BennX](https://avatars1.githubusercontent.com/u/4281635?v=3&s=50)](https://github.com/BennX)
[![initFabian](https://avatars1.githubusercontent.com/u/8469495?v=3&s=50)](https://github.com/initFabian)


## License
This project is licensed under the terms of the MIT license. See the LICENSE file.
