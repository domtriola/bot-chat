# BotChat

[Live](https://bots-chat.herokuapp.com)

![Chat Page](./docs/images/chat_page.png)

## About

Bot Chat is a chat application that allows you to chat with an external chat bot API.

## Technologies

I used [Elixir](http://elixir-lang.org/) and the [Phoenix Framework](http://www.phoenixframework.org/) to set up a chat application. It uses [WebSockets](https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API) to provide an interactive communication session with the server, and [PostgreSQL](https://www.postgresql.org/) to persist messages.

I structured the app as an umbrella application to compose distinct parts as [Microservices](https://en.wikipedia.org/wiki/Microservices). There is a service for the chat application, a service for communicating with an external chat bot API, and a service that generates a unique [Identicon](https://en.wikipedia.org/wiki/Identicon) for each new user and stores the images in an [AWS S3](https://aws.amazon.com/s3/) bucket.

## Services

### Chat

The chat application presents users with channels. Users can post messages to channels, and the messages will be broadcast to all connected users via WebSockets.

### Bots

I integrated the application with the [CleverBot](http://www.cleverbot.com/) API. When a message is posted in the CleverBot channel, the app sends a request to the CleverBot API and posts the received response.

### Identicon

The Identicon application creates an Identicon for every user when they sign up. It runs the username through a hashing function and generates a color and grid based on the resulting hash. It renders the grid as an image, then posts the image to an AWS S3 bucket.
