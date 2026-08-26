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
    "fontSizeLabel",
    "fontSizeValue",
    "backgroundOptions",
    "backgroundOptionsToggle",
    "opacityLabel",
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

  initializeControls() {
    this.textInputTarget.value = this.renderPlan.text.fillText;
    this.fontSizeValueTarget.value = this.renderPlan.text.fontSize;
    this.fontSizeValueTarget.min = Math.max(
      12,
      fontSizeFromRatio(this.canvas.width, FONT_SIZE_MIN_RATIO),
    );
    this.fontSizeValueTarget.max = fontSizeFromRatio(
      this.canvas.width,
      FONT_SIZE_MAX_RATIO,
    );
    this.fontSizeLabelTarget.textContent = `${this.renderPlan.text.fontSize}px`;
    this.backgroundOptionsToggleTarget.checked =
      this.renderPlan.background.enabled;
    this.opacityValueTarget.value = this.renderPlan.background.opacity;
    this.opacityLabelTarget.textContent = toPercentText(
      this.renderPlan.background.opacity,
    );
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

  updateSelectedTextOption() {
    this.textOptionTargets.forEach((button) => {
      const selected = button.dataset.text === this.renderPlan.text.fillText;
      button.setAttribute("aria-pressed", selected.toString());
      button.classList.toggle("is-selected", selected);
    });
  }

  updateBackgroundEnabled() {
    this.backgroundOptionsTarget.disabled = !this.renderPlan.background.enabled;
  }

  applyPreset(e) {
    const preset = e.currentTarget;
    this.renderPlan.text.fillText = preset.dataset.text;
    this.renderPlan.text.fillStyle = preset.dataset.textFillStyle;

    const hasBgFillStyle = Boolean(preset.dataset.bgFillStyle);
    if (hasBgFillStyle) {
      this.renderPlan.background.enabled = true;
      this.renderPlan.background.fillStyle = preset.dataset.bgFillStyle;
    } else {
      this.renderPlan.background.enabled = false;
    }

    this.syncControls();
    this.render();
  }

  selectText(e) {
    this.renderPlan.text.fillText = e.currentTarget.dataset.text;
    this.syncTextControls();
    this.render();
  }

  changeText(e) {
    this.renderPlan.text.fillText = e.target.value;
    this.updateSelectedTextOption();
    this.render();
  }

  changeFontSize(e) {
    this.renderPlan.text.fontSize = Number(e.target.value);
    this.fontSizeLabelTarget.textContent = `${e.target.value}px`;
    this.render();
  }

  toggleBackground(e) {
    this.renderPlan.background.enabled = e.target.checked;
    this.updateBackgroundEnabled();
    this.render();
  }

  changeTextColor(e) {
    this.renderPlan.text.fillStyle = e.target.value;
    this.textColorLabelTarget.textContent = e.target.value.toUpperCase();
    this.render();
  }

  changeBackgroundColor(e) {
    this.renderPlan.background.fillStyle = e.target.value;
    this.backgroundColorLabelTarget.textContent = e.target.value.toUpperCase();
    this.render();
  }

  changeBackgroundOpacity(e) {
    this.renderPlan.background.opacity = Number(e.target.value);
    this.opacityLabelTarget.textContent = toPercentText(e.target.value);
    this.render();
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

  async render() {
    const ctx = this.canvas.getContext("2d");
    const { text, background } = this.renderPlan;
    const defaultStartPoint = 0;
    const defaultBgRatio = 3;
    const backgroundHeight = this.canvas.height / defaultBgRatio;
    const backgroundStartY = this.canvas.height - backgroundHeight;

    ctx.save();
    ctx.globalAlpha = 1;

    ctx.clearRect(
      defaultStartPoint,
      defaultStartPoint,
      this.canvas.width,
      this.canvas.height,
    );

    ctx.drawImage(
      this.originalImage,
      defaultStartPoint,
      defaultStartPoint,
      this.canvas.width,
      this.canvas.height,
    );

    if (background.enabled) {
      ctx.globalAlpha = background.opacity;
      ctx.fillStyle = background.fillStyle;
      ctx.fillRect(
        defaultStartPoint,
        backgroundStartY,
        this.canvas.width,
        backgroundHeight,
      );
      // 透明度の変更に対応しているのは背景だけなので、以降の工程では不透明度を元に戻す
      ctx.globalAlpha = 1;
    }

    const hasText = Boolean(text.fillText.trim());
    if (hasText) {
      const defaultFont = `700 ${text.fontSize}px sans-serif`;
      const canvasCenterX = this.canvas.width / 2;
      const backgroundCenterY = backgroundStartY + backgroundHeight / 2;
      const textMaxWidth = this.canvas.width * 0.94;

      ctx.font = defaultFont;
      ctx.fillStyle = text.fillStyle;
      ctx.textBaseline = "middle";
      ctx.textAlign = "center";

      ctx.fillText(
        text.fillText,
        canvasCenterX,
        backgroundCenterY,
        textMaxWidth,
      );
    }
    ctx.restore();

    this.dispatch("textChanged", { detail: { hasText } });

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

function toPercentText(value) {
  return `${Math.round(Number(value) * 100)}%`;
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
