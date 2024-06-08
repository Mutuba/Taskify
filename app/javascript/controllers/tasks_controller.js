import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tasks"
export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected");
  }

  toggle(e) {
    const id = e.target.dataset.id;
    const csrfToken = document.querySelector("[name='csrf-token']").content;

    fetch(`/tasks/${id}/toggle`, {
      method: "POST",
      mode: "cors",
      cache: "no-cache",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        Accept: "application/json",
      },
      body: JSON.stringify({ completed: e.target.checked }),
    })
      .then((response) => {
        if (!response.ok) {
          return response.json().then((data) => {
            throw new Error(data.errors.join(", "));
          });
        }
        return response.json();
      })
      .then((data) => {
        this.showNotice(data.message);
      })
      .catch((error) => {
        alert("Error: " + error.message);
      });
  }

  showNotice(message) {
    const noticeFrame = document.querySelector("#notice-frame");
    noticeFrame.innerHTML = `<p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block">${message}</p>`;

    setTimeout(() => {
      noticeFrame.innerHTML = "";
    }, 3000);
  }
}
