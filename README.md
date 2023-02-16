# prokeep
An application that accepts messages via an HTTP endpoint and processes the messages in the order that they are received

## Requirements
The application should be able to handle multiple queues based on a parameter passed into the HTTP endpoint. Each queue should be rate limited to process no more than one message per second.

1. [x] We would like to see usage of Phoenix and Elixir for this task.
2. [x] You should have an HTTP endpoint at the path /receive-message which accepts a GET request with the query string parameters queue (string) and message (string).
3. [x] Your application should accept messages as quickly as they come in and return a 200 status code.
4. [x] Your application should “process” the messages by printing the message text to the terminal, however for each queue, your application should only “process” one message a second, no matter how quickly the messages are submitted to the HTTP endpoint.
5. [x] Bonus points for writing some kind of test that verifies messages are only processed one per second.
6. [] Not required but in progress, a user interface to test these features.

### How to start
It is assumed that you have programming knowledge, that Elixir Language version 1.12 or higher is installed.

Go to the console at the root of the project and run the command `mix phx.server`