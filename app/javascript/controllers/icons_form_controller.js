import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["uploadedIcon", "originalImage"];

  async submit(event) {
    const fd = setupFormdata(event.detail);
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
        window.location.href = responseData.redirect_url;
      } else {
        alert(responseData.error || "画像の保存に失敗しました。");
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
}

function setupFormdata(detail) {
  const fd = new FormData();
  fd.append("combined_icon[image]", detail.combinedImageFile);
  fd.append("combined_icon[name]", detail.combinedImageName);

  fd.append("original_icon[image]", detail.originalImageFile);

  fd.append("canvas_preset[text]", detail.renderPlan.text?.text ?? "");
  fd.append(
    "canvas_preset[text_color]",
    detail.renderPlan.text?.fillStyle ?? "",
  );
  fd.append(
    "canvas_preset[bg_color]",
    detail.renderPlan.background?.fillStyle ?? "",
  );

  return fd;
}
