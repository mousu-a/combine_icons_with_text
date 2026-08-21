import { Controller } from "@hotwired/stimulus";

const DEFAULT_TEXT_COLOR = "#000000";
const DEFAULT_BACKGROUND_COLOR = "#000000";
const DEFAULT_OPACITY = 1;
const FONT_SIZE_MIN_RATIO = 0.05;
const FONT_SIZE_DEFAULT_RATIO = 0.13;
const FONT_SIZE_MAX_RATIO = 0.3;

export default class extends Controller {
  static targets = [
    "canvas",
    "textInput",
    "fontSizeInput",
    "fontSizeValue",
    "backgroundOptions",
    "backgroundOptionsToggle",
    "opacityInput",
    "opacityValue",
    "textOption",
    "textColorValue",
    "backgroundColorValue",
  ];

  get selectedText() {
    return this.renderPlan?.text?.text || "";
  }

  get canvas() {
    return this.canvasTarget;
  }

  setup(event) {
    this.originalImage = event.detail.originalImage;
    this.canvas.width = this.originalImage.naturalWidth;
    this.canvas.height = this.originalImage.naturalHeight;
    this.renderPlan = this.defaultRenderPlan();
    this.canvasBlob = null;
    this.syncControls();
    this.render();
  }

  defaultRenderPlan() {
    return {
      text: {
        text: "",
        fontSize: fontSizeFromRatio(this.canvas.width, FONT_SIZE_DEFAULT_RATIO),
        fillStyle: DEFAULT_TEXT_COLOR,
      },
      background: {
        enabled: false,
        fillStyle: DEFAULT_BACKGROUND_COLOR,
        opacity: DEFAULT_OPACITY,
      },
    };
  }

  applyPreset(event) {
    const preset = event.currentTarget;
    this.renderPlan.text.text = preset.dataset.text;
    this.renderPlan.text.fillStyle = preset.dataset.textFillStyle;
    this.renderPlan.background.enabled = Boolean(preset.dataset.bgFillStyle);
    if (preset.dataset.bgFillStyle) {
      this.renderPlan.background.fillStyle = preset.dataset.bgFillStyle;
    }
    this.syncControls();
    this.render();
  }

  selectText(event) {
    this.renderPlan.text.text = event.currentTarget.dataset.text;
    this.syncControls();
    this.render();
  }

  changeText(event) {
    this.renderPlan.text.text = event.target.value;
    this.updateSelectedTextOption();
    this.render();
  }

  changeFontSize(event) {
    this.renderPlan.text.fontSize = Number(event.target.value);
    this.fontSizeValueTarget.textContent = `${event.target.value}px`;
    this.render();
  }

  toggleBackground(event) {
    this.renderPlan.background.enabled = event.target.checked;
    this.updateBackgroundControls();
    this.render();
  }

  changeTextColor(event) {
    this.renderPlan.text.fillStyle = event.target.value;
    this.textColorValueTarget.textContent = event.target.value.toUpperCase();
    this.render();
  }

  changeBackgroundColor(event) {
    this.renderPlan.background.fillStyle = event.target.value;
    this.backgroundColorValueTarget.textContent =
      event.target.value.toUpperCase();
    this.render();
  }

  changeBackgroundOpacity(event) {
    this.renderPlan.background.opacity = Number(event.target.value);
    this.opacityValueTarget.textContent = `${Math.round(Number(event.target.value) * 100)}%`;
    this.render();
  }

  syncControls() {
    this.textInputTarget.value = this.renderPlan.text.text;
    this.fontSizeInputTarget.value = this.renderPlan.text.fontSize;
    this.fontSizeInputTarget.min = Math.max(
      12,
      fontSizeFromRatio(this.canvas.width, FONT_SIZE_MIN_RATIO),
    );
    this.fontSizeInputTarget.max = fontSizeFromRatio(
      this.canvas.width,
      FONT_SIZE_MAX_RATIO,
    );
    this.fontSizeValueTarget.textContent = `${this.renderPlan.text.fontSize}px`;
    this.backgroundOptionsToggleTarget.checked =
      this.renderPlan.background.enabled;
    this.opacityInputTarget.value = this.renderPlan.background.opacity;
    this.opacityValueTarget.textContent = `${Math.round(this.renderPlan.background.opacity * 100)}%`;
    this.textColorValueTarget.textContent =
      this.renderPlan.text.fillStyle.toUpperCase();
    this.backgroundColorValueTarget.textContent =
      this.renderPlan.background.fillStyle.toUpperCase();
    this.updateSelectedTextOption();
    this.updateBackgroundControls();
  }

  updateSelectedTextOption() {
    if (!this.hasTextOptionTarget) return;

    this.textOptionTargets.forEach((button) => {
      const selected = button.dataset.text === this.renderPlan.text.text;
      button.setAttribute("aria-pressed", selected.toString());
      button.classList.toggle("is-selected", selected);
    });
  }

  updateBackgroundControls() {
    const enabled = this.renderPlan.background.enabled;
    this.backgroundOptionsTarget.disabled = !enabled;
    this.backgroundOptionsTarget.classList.toggle(
      "is-disabled-controls",
      !enabled,
    );
  }

  async render() {
    const ctx = this.canvas.getContext("2d");
    const { text, background } = this.renderPlan;
    const backgroundHeight = this.canvas.height / 3;
    const backgroundY = this.canvas.height - backgroundHeight;

    ctx.save();
    ctx.globalAlpha = 1;
    ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
    ctx.drawImage(
      this.originalImage,
      0,
      0,
      this.canvas.width,
      this.canvas.height,
    );

    if (background.enabled) {
      ctx.globalAlpha = background.opacity;
      ctx.fillStyle = background.fillStyle;
      ctx.fillRect(0, backgroundY, this.canvas.width, backgroundHeight);
      ctx.globalAlpha = 1;
    }

    if (text.text.trim()) {
      ctx.font = `700 ${text.fontSize}px sans-serif`;
      ctx.fillStyle = text.fillStyle;
      ctx.textBaseline = "middle";
      ctx.textAlign = "center";
      ctx.fillText(
        text.text,
        this.canvas.width / 2,
        backgroundY + backgroundHeight / 2,
        this.canvas.width * 0.94,
      );
    }
    ctx.restore();

    this.dispatch("textChanged", {
      detail: { hasText: Boolean(text.text.trim()) },
    });

    try {
      this.canvasBlob = await canvasToBlob(this.canvas);
      this.dispatch("render", { detail: { canvasBlob: this.canvasBlob } });
    } catch (error) {
      console.error(error.message);
      throw error;
    }
  }
}

function fontSizeFromRatio(canvasWidth, ratio) {
  return Math.round(canvasWidth * ratio);
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
