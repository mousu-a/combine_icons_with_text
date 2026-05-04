import { Controller } from "@hotwired/stimulus";

const MAX_FILE_SIZE_MB = 5;

export default class extends Controller {
  static targets = ["uploadedIcon", "originalImage", "downloadLink"];
  static outlets = ["preview", "canvas"];

  setup() {
    const file = this.uploadedIconTarget.files[0];

    if (!this.validateFile(file)) {
      alert(`${this.errorMessage}`);
      return;
    }

    this.baseImageUrl = URL.createObjectURL(file);
    const originalImage = this.originalImageTarget;

    originalImage.src = this.baseImageUrl;
    originalImage.style.display = "inline";

    originalImage.onload = () => {
      this.dispatch("setup", { detail: { originalImage } });
    };
  }

  validateFile(file) {
    this.errorMessage = null;
    const allowedExtensions = [".jpg", ".jpeg", ".png", ".webp"];
    const fileExtension = file.name.split(".").pop().toLowerCase();

    if (fileExtension === "heic" || fileExtension === "heif") {
      this.errorMessage =
        "HEIC / HEIF形式の画像には現在対応していません。\nJPG、JPEG、PNG、WebPなどに変換してからアップロードをお願いします。";
      return false;
    }

    if (
      !file.type.startsWith("image/") ||
      !allowedExtensions.includes(`.${fileExtension}`)
    ) {
      this.errorMessage = `"${file.name}" は画像ではありません。画像ファイルのみアップロードできます。`;
      return false;
    }

    if (!validateByteSize(file)) {
      this.errorMessage = `画像は${MAX_FILE_SIZE_MB}MB以下にしてください`;
      return false;
    }

    return true;
  }

  download(e) {
    e.preventDefault();
    if (this.downloadLinkTarget.classList.contains("is-disabled")) return;

    disableLink(this.downloadLinkTarget);
    const selectedText = this.canvasOutlet.selectedText;
    const previewImageUrl = this.previewOutlet.previewImageUrl;
    const combinedIconName = `${selectedText}のアイコン.webp`;
    e.currentTarget.href = previewImageUrl;
    e.currentTarget.download = combinedIconName;

    this.triggerSubmit(combinedIconName);
    enableLink(this.downloadLinkTarget);

    setTimeout(() => {
      URL.revokeObjectURL(this.baseImageUrl);
      URL.revokeObjectURL(previewImageUrl);
    }, 100);
  }

  async triggerSubmit(combinedImageName) {
    const originalImageFile = this.uploadedIconTarget.files[0];
    const renderPlan = this.canvasOutlet.renderPlan;
    let combinedImageFile = this.canvasOutlet.canvasBlob;

    this.dispatch("download", {
      detail: {
        originalImageFile,
        combinedImageFile,
        combinedImageName,
        renderPlan,
      },
    });
  }

  // dispatchでのみ呼ばれる
  enableDownload() {
    enableLink(this.downloadLinkTarget);
  }
}

function enableLink(link) {
  link.classList.remove("is-disabled");
  link.setAttribute("aria-disabled", "false");
}

function disableLink(link) {
  link.classList.add("is-disabled");
  link.setAttribute("aria-disabled", "true");
}

function validateByteSize(file) {
  const limitSizeMB = MAX_FILE_SIZE_MB * 1024 * 1024;
  return file.size < limitSizeMB;
}
