# LetMeAuth for iOS

Let Me Auth! - as simple as possible authorization library for use with backends.

## Overview

Very often we have to add authorization in a mobile application through the built-accounts or through native SDK. Each library for the social network provides a fairly sophisticated mechanisms for authorization. Each library creates her own shared instance of session. Method "application:openURL:sourceApplication:annotation:" increases more and more and more.

Who is responsible for the whole authorization process?
Where the code that performs the authorization process is localized?
Who is responsible for the destruction of these sessions?
ViewController or AppDelegate? Or, maybe, something else?

## Purpose

This library is designed to simplify the process of authorization for applications that require a client-server authorization using the built-in social networking accounts.
It implements a common strategy authorization and provides a simple mechanism for passing the authorization process.

If you want to pass access tokens to backend, you must follow these guidelines:
* Send access tokens over SSL secured connections (https).
* Send access tokens in the header or as POST data. Do not send as query parameters on GET requests.

## Example usage

[Example of integration for iOS](https://github.com/webparadox/LetMeAuth-Integration-iOS) based on LMAStubProvider.

## Providers, supported by maintainer

* [Facebook](https://github.com/webparadox/LetMeAuth-FacebookSDK-iOS)
* [Twitter](https://github.com/webparadox/LetMeAuth-STTwitter)
* [Google+](https://github.com/webparadox/LetMeAuth-GooglePlusSDK-iOS)
* [Vkontakte](https://github.com/webparadox/LetMeAuth-VkontakteSDK-iOS)

## Contact

Alexey Aleshkov

- https://github.com/djmadcat
- https://twitter.com/coreshock
- djmadcat@gmail.com

## License

LetMeAuth is available under the BSD 2-Clause license. See the `LICENSE` file for more info.
