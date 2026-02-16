import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["canvasPreset"];

  connect() {
    this.presetsRender();
  }
  // TODO canvasの操作をここでしたくない
  // renderPlanに書き込み、canvas.renderを実行させたい
  presetsRender() {
    this.canvasPresetTargets.forEach((canvas) => {
      const ctx = canvas.getContext("2d");

      const text = canvas.dataset.text;
      const textColor = canvas.dataset.textFillStyle;
      const bgColor = canvas.dataset.bgFillStyle;

      ctx.fillStyle = bgColor;
      ctx.fillRect(0, 0, canvas.width, canvas.height);

      ctx.font = "24px sans-serif";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.fillStyle = textColor;
      ctx.fillText(text, canvas.width / 2, canvas.height / 2);
    });
  }
}
