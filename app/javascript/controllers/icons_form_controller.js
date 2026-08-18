import { Controller } from "@hotwired/stimulus";

const DEFAULT_DELAY_MS = 3000;

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
      }
    } catch (error) {
      console.error("Upload error:", error);
      alert(
        "通信エラーが発生したため画像を保存出来ませんでした。\n画像を保存したい場合は時間を置いて再度ダウンロードボタンを押してください。",
      );
    }
  }

  displayToast(message) {
    this.toastMessageTarget.textContent = message;
    this.toastTarget.classList.remove("hidden");

    setTimeout(() => {
      this.toastTarget.classList.add("hidden");
    }, DEFAULT_DELAY_MS);
  }
}

function setupFormdata(params) {
  const fd = new FormData();
  fd.append(
    "combined_icon[image]",
    params.combinedIconFile,
    params.combinedIconName,
  );

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
    params.renderPlan.background?.enabled
      ? params.renderPlan.background.fillStyle
      : "",
  );

  return fd;
}
