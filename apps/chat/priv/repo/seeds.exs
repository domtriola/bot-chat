# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Chat.Repo.insert!(%Chat.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Chat.Repo
alias Chat.Convo
alias Chat.User

Repo.insert!(%Convo{title: "General"})
Repo.insert!(%Convo{title: "CleverBot"})

Repo.insert!(%User{username: "CleverBot"})
