import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"


export default class extends Controller {
  static values = { chatroomId: Number, currentUserId: Number }
  static targets = ["messages"]
  
  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.insertMessageAndScrollDown(data) }
    )
    console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}.`)
    this.scrollToBottom();
    
  }

  scrollToBottom() {
    requestAnimationFrame(() => {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
    });
  }


  insertMessageAndScrollDown(data) {

    const messageHTML = data.message;
    const currentUserIsSender = this.currentUserIdValue === data.sender_id
    const messageElement = this.buildMessageElement(currentUserIsSender, messageHTML)
    this.messagesTarget.insertAdjacentHTML("beforeend", messageElement);
    this.scrollToBottom();
  }
  
  buildMessageElement(currentUserIsSender, message) {
    return `
      <div class="mb-4 pt-6 d-flex flex-column ${this.justifyClass(currentUserIsSender)}">
        <div class="max-w-[70%] rounded-xl px-4 py-2 ${this.userStyleClass(currentUserIsSender)}">
          ${message}
        </div>
      </div>
    `
  }
  justifyClass(currentUserIsSender) {
    return currentUserIsSender ? "align-items-end" : "align-items-start"
  }
  
  userStyleClass(currentUserIsSender) {
    return currentUserIsSender ? "bg-teal text-light-gray" : "bg-light-gray"
  }
}
