import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toast", "toastMessage"];

  async submit(event) {
    const fd = setupFormdata(event.detail.params);
    const token = document.querySelector('meta[name="csrf-token"]').content;
    try {
      const response = await fetch("/icons", {
        method: "POST",
        body: fd,
        headers: {
          "X-CSRF-Token": token,
        },
        credentials: "same-origin",
      });
      const responseData = await response.json();
      if (response.ok) {
        this.displayToast(responseData.message);
      } else {
        alert(responseData.error_message);
        // TODO: ユーザーのネクストアクションを誘導する
        // https://github.com/mousu-a/combine_icons_with_text/issues/127
      }
    } catch (error) {
      console.error("Upload error:", error);
      alert("通信エラーが発生しました。");
      // TODO: ユーザーのネクストアクションを誘導する
      // https://github.com/mousu-a/combine_icons_with_text/issues/127
    }
  }

  displayToast(message) {
    this.toastMessageTarget.textContent = message;
    this.toastTarget.classList.remove("is-hidden");

    setTimeout(() => {
      this.toastTarget.classList.add("is-hidden");
    }, 3000);
  }
}

function setupFormdata(params) {
  const fd = new FormData();
  fd.append("combined_icon[image]", params.combinedIconFile);
  fd.append("combined_icon[name]", params.combinedIconName);

  if (params.originalIconId) {
    fd.append("original_icon[id]", params.originalIconId);
  } else {
    fd.append("original_icon[image]", params.originalIconFile);
  }

  fd.append("canvas_preset[text]", params.renderPlan.text?.text ?? "");
  fd.append(
    "canvas_preset[text_color]",
    params.renderPlan.text?.fillStyle ?? "",
  );
  fd.append(
    "canvas_preset[bg_color]",
    params.renderPlan.background?.fillStyle ?? "",
  );

  return fd;
}
