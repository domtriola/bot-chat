import Util from './util/util.js';

const Convo = {
  init(socket, convo) {
    if (!convo) return;

    let convoId = convo.getAttribute("data-id");

    this.connect(socket, convoId);
  },

  connect(socket, convoId) {
    socket.connect();

    // Now that you are connected, you can join channels with a topic:
    let channel = socket.channel(`convos:${convoId}`, {});

    let msgContainer = document.getElementById("message-container");
    let msgInput = document.querySelector("#message-input");
    let msgText = msgInput.children[0];
    let msgSubmit = msgInput.children[1];

    channel.join()
      .receive("ok", ({ messages }) => {
        this.renderMessages(msgContainer, messages);
      })
      .receive("error", resp => { console.log("Unable to join", resp); });

    msgSubmit.addEventListener("click", (e) => {
      this.submitMsg(channel, msgText);
    });

    msgInput.addEventListener("keypress", (e) => {
      if (e.keyCode === 13) this.submitMsg(channel, msgText);
    });

    channel.on("new_message", msg => {
      channel.params.last_seen_id = msg.id;
      this.renderMessage(msgContainer, msg);
    });
  },

  submitMsg(channel, msgText) {
    let msg = { body: msgText.value };

    channel.push("new_message", msg)
      .receive("error", err => console.log(err));

    msgText.value = "";
  },

  renderMessages(msgContainer, messages) {
    messages.forEach(msg => this.renderMessage(msgContainer, msg));
  },

  renderMessage(msgContainer, msg) {
    let div = document.createElement("div");
    let username = Util.esc(msg.user);
    let img = `<img src="/images/avatars/${username}"`;

    div.innerHTML = `
      <div class="message">
        <div class="avatar">
          <img src="https://s3-us-west-1.amazonaws.com/bot-chat/avatars/${username}.png" />
        </div>
        <div class="message-info">
          ${username}
        </div>
        <div class="message-body">
          ${Util.esc(msg.body)}
        </div>
      </div>
    `;

    msgContainer.appendChild(div);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  }
};

export default Convo;
