// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";
import Convo from "./convo.js";

Convo.init(socket, document.getElementById("convo"));

// Guest Login
const guestLogin = document.getElementById("guest-login");
if (guestLogin) {
  const login = document.getElementById("session-login");
  const username = document.getElementById("session_username");
  const password = document.getElementById("session_password");
  const guestName = "CleverHuman";
  const guestPass = "cleverP@$$w0rd";

  guestLogin.addEventListener("click", (e) => {
    e.preventDefault();

    let time = 0;
    const fields = { username: username, password: password };
    const guestInfo = { username: guestName, password: guestPass };

    const setNextChar = (field, i) => {
      time += 50;

      setTimeout(() => {
        let label = fields[field].parentElement;
        if (label.className.indexOf("is-focused") === -1)
          label.className += " is-focused";

        let currentVal = fields[field].value;
        fields[field].value = currentVal + guestInfo[field][i];

        if (field === "password" && guestInfo[field][i] === "d")
          login.click();

      }, time);
    };

    Object.keys(fields).forEach(field => {
      for (let i = 0; i < guestInfo[field].length; i++)
        setNextChar(field, i);
    });
  });
}
