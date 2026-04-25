import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["canvas"];

  get selectedText() {
    return this._selectedText;
  }

  get canvas() {
    return this.canvasTarget;
  }

  setup(event) {
    const image = event.detail.originalImage;
    const canvas = this.canvasTarget;
    const ctx = canvas.getContext("2d");
    canvas.width = image.naturalWidth;
    canvas.height = image.naturalHeight;
    ctx.drawImage(image, 0, 0);

    this.renderPlan = {};
    this._selectedText;
    this.canvasBlob;
  }

  applyPreset(e) {
    const preset = e.currentTarget;
    const text = preset.dataset.text;
    const textColor = preset.dataset.textFillStyle;
    const bgColor = preset.dataset.bgFillStyle;
    this.drawText(null, text, textColor);
    this.drawBackground(null, bgColor);
  }

  drawText(e, presetText, presetColor) {
    const hasText = Object.hasOwn(this.renderPlan, "text");
    if (!hasText) this.dispatch("textAdded");

    this._selectedText = presetText || e.currentTarget.textContent;
    const canvas = this.canvasTarget;
    const y = calcYPosition("text", canvas);
    this.renderPlan["text"] = {
      text: this._selectedText,
      font: "200px sans-serif",
      fillStyle: presetColor || "#ffffff",
      textBaseline: "middle",
      textAlign: "center",
      x: canvas.width / 2,
      y: y,
    };
    this.render();
  }

  drawBackground(_, presetBgColor) {
    const canvas = this.canvasTarget;
    const y = calcYPosition("background", canvas);
    this.renderPlan["background"] = {
      fillStyle: presetBgColor || "#000000",
      width: canvas.width,
      height: canvas.height / 3,
      x: 0,
      y: y,
    };
    this.render();
  }

  async render() {
    const renderPlan = this.renderPlan;
    const canvas = this.canvasTarget;
    const ctx = canvas.getContext("2d");
    const order = ["opacity", "background", "text"];
    for (const key of order) {
      const plan = renderPlan[key];
      if (!plan) continue;

      switch (key) {
        case "opacity": {
          ctx.globalAlpha = plan.globalAlpha;
          const bg = renderPlan.background;
          ctx.clearRect(bg.x, bg.y, bg.width, bg.height);
          break;
        }
        case "background":
          ctx.fillStyle = plan.fillStyle;
          ctx.fillRect(plan.x, plan.y, plan.width, plan.height);
          break;
        case "text":
          ctx.font = plan.font;
          ctx.fillStyle = plan.fillStyle;
          ctx.textBaseline = plan.textBaseline;
          ctx.textAlign = plan.textAlign;
          ctx.fillText(plan.text, plan.x, plan.y);
          break;
        default:
          break;
      }
    }

    try {
      this.canvasBlob = await canvasToBlob(canvas);
      this.dispatch("render", { detail: { canvasBlob: this.canvasBlob } });
    } catch (e) {
      console.error(e.message);
      throw e;
    }
  }

  changeTextColor(event) {
    if ("text" in this.renderPlan) {
      this.renderPlan["text"].fillStyle = event.target.value;
      this.render();
    }
  }

  changeBackgroundColor(event) {
    if ("background" in this.renderPlan) {
      this.renderPlan["background"].fillStyle = event.target.value;
      this.render();
    }
  }

  changeGlobalOpacity(event) {
    if ("opacity" in this.renderPlan) {
      this.renderPlan["opacity"].globalAlpha = event.target.value;
    } else {
      this.renderPlan["opacity"] = { globalAlpha: event.target.value };
    }
    this.render();
  }
}

function calcYPosition(type, canvas) {
  if (type === "text") {
    const backgroundHeight = canvas.height / 3;
    const backgroundY = canvas.height - backgroundHeight;
    const textY = backgroundY + backgroundHeight / 2;
    return textY;
  } else if (type === "background") {
    const height = canvas.height / 3;
    const backgroundY = canvas.height - height;
    return backgroundY;
  }
}

function canvasToBlob(canvas) {
  return new Promise((resolve, reject) => {
    canvas.toBlob((blob) => {
      if (blob) {
        resolve(blob);
      } else {
        reject(new Error("Blobファイルの生成に失敗しました"));
      }
    }, "image/webp");
  });
}
