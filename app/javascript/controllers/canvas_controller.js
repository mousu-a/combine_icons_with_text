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
    "textColorLabel",
    "textColorValue",
    "backgroundColorLabel",
    "backgroundColorValue",
  ];

  get selectedText() {
    return this.renderPlan?.text?.fillText || "";
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
    this.initializeControls();
    this.render();
  }

  defaultRenderPlan() {
    return {
      text: {
        fillText: "",
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
    this.renderPlan.text.fillText = preset.dataset.text;
    this.renderPlan.text.fillStyle = preset.dataset.textFillStyle;
    const hasBgFillStyle = Boolean(preset.dataset.bgFillStyle);
    if (hasBgFillStyle) {
      this.renderPlan.background.enabled = true;
      this.renderPlan.background.fillStyle = preset.dataset.bgFillStyle;
    }
    this.syncControls();
    this.render();
  }

  selectText(event) {
    this.renderPlan.text.fillText = event.currentTarget.dataset.text;
    this.syncTextControls();
    this.render();
  }

  changeText(event) {
    this.renderPlan.text.fillText = event.target.value;
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
    this.updateBackgroundEnabled();
    this.render();
  }

  changeTextColor(event) {
    this.renderPlan.text.fillStyle = event.target.value;
    this.textColorLabelTarget.textContent = event.target.value.toUpperCase();
    this.render();
  }

  changeBackgroundColor(event) {
    this.renderPlan.background.fillStyle = event.target.value;
    this.backgroundColorLabelTarget.textContent =
      event.target.value.toUpperCase();
    this.render();
  }

  changeBackgroundOpacity(event) {
    this.renderPlan.background.opacity = Number(event.target.value);
    this.opacityValueTarget.textContent = `${Math.round(Number(event.target.value) * 100)}%`;
    this.render();
  }

  initializeControls() {
    this.textInputTarget.value = this.renderPlan.text.fillText;
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
    this.textColorLabelTarget.textContent =
      this.renderPlan.text.fillStyle.toUpperCase();
    this.textColorValueTarget.value = this.renderPlan.text.fillStyle;
    this.backgroundColorLabelTarget.textContent =
      this.renderPlan.background.fillStyle.toUpperCase();
    this.backgroundColorValueTarget.value =
      this.renderPlan.background.fillStyle;
    this.updateSelectedTextOption();
    this.updateBackgroundEnabled();
  }

  syncControls() {
    this.textInputTarget.value = this.renderPlan.text.fillText;
    this.textColorLabelTarget.textContent =
      this.renderPlan.text.fillStyle.toUpperCase();
    this.textColorValueTarget.value = this.renderPlan.text.fillStyle;

    this.backgroundOptionsToggleTarget.checked =
      this.renderPlan.background.enabled;
    this.backgroundColorLabelTarget.textContent =
      this.renderPlan.background.fillStyle.toUpperCase();
    this.backgroundColorValueTarget.value =
      this.renderPlan.background.fillStyle;

    this.updateSelectedTextOption();
    this.updateBackgroundEnabled();
  }

  syncTextControls() {
    this.textInputTarget.value = this.renderPlan.text.fillText;
    this.updateSelectedTextOption();
  }

  updateSelectedTextOption() {
    if (!this.hasTextOptionTarget) return;

    this.textOptionTargets.forEach((button) => {
      const selected = button.dataset.text === this.renderPlan.text.fillText;
      button.setAttribute("aria-pressed", selected.toString());
      button.classList.toggle("is-selected", selected);
    });
  }

  updateBackgroundEnabled() {
    this.backgroundOptionsTarget.disabled = !this.renderPlan.background.enabled;
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

    if (text.fillText.trim()) {
      ctx.font = `700 ${text.fontSize}px sans-serif`;
      ctx.fillStyle = text.fillStyle;
      ctx.textBaseline = "middle";
      ctx.textAlign = "center";
      ctx.fillText(
        text.fillText,
        this.canvas.width / 2,
        backgroundY + backgroundHeight / 2,
        this.canvas.width * 0.94,
      );
    }
    ctx.restore();

    this.dispatch("textChanged", {
      detail: { hasText: Boolean(text.fillText.trim()) },
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
