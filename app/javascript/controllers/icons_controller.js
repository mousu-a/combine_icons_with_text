import { Controller } from "@hotwired/stimulus";

// フロント側ではサーバー側より小さいサイズ上限を設定している(「JSで通ったのにRailsで通らない」といったことが万が一にも起こらないために)
const MAX_FILE_SIZE = 5;
const DEFAULT_DELAY_MS = 3000;

export default class extends Controller {
  static targets = [
    "uploadedImage",
    "originalImage",
    "downloadLink",
    "existingIconRecord",
    "fileNameLabel",
  ];
  static outlets = ["preview", "canvas"];

  connect() {
    if (this.hasExistingIconRecordTarget)
      this.setup({ existingIconRecord: this.existingIconRecordTarget });
  }

  upload() {
    const uploadFile = this.uploadedImageTarget.files[0];
    if (!uploadFile) return;

    this.setup({ uploadFile });
  }

  setup({ uploadFile, existingIconRecord }) {
    if (uploadFile && !this.validateFile(uploadFile)) {
      alert(`${this.errorMessage}`);
      return false;
    }

    const hasPreviousUploadImageUrl =
      this.originalImageUrl?.startsWith("blob:");
    if (hasPreviousUploadImageUrl) URL.revokeObjectURL(this.originalImageUrl);

    this.originalImageUrl = setupOriginalImageUrl(
      uploadFile,
      existingIconRecord,
    );
    const originalImage = this.originalImageTarget;
    originalImage.src = this.originalImageUrl;
    this.fileNameLabelTarget.textContent = uploadFile?.name || "保存済みの画像";

    originalImage.onload = () => {
      this.dispatch("setup", { detail: { originalImage } });
    };

    return true;
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
      this.errorMessage = `画像は${MAX_FILE_SIZE}MB以下にしてください`;
      return false;
    }

    return true;
  }

  download(e) {
    if (this.downloadLinkTarget.classList.contains("is-disabled")) return;

    disableLink(this.downloadLinkTarget);
    const selectedText = this.canvasOutlet.selectedText;
    const previewImageUrl = this.previewOutlet.previewImageUrl;
    const combinedIconName = `${selectedText}のアイコン.webp`;
    e.currentTarget.href = previewImageUrl;
    e.currentTarget.download = combinedIconName;

    this.triggerSubmit(combinedIconName);

    setTimeout(() => {
      URL.revokeObjectURL(this.originalImageUrl);
      URL.revokeObjectURL(previewImageUrl);

      enableLink(this.downloadLinkTarget);
    }, DEFAULT_DELAY_MS);
  }

  async triggerSubmit(combinedIconName) {
    const params = {};
    const uploadedFile = this.uploadedImageTarget.files?.[0];
    if (uploadedFile) {
      params.originalIconFile = uploadedFile;
    } else if (this.hasExistingIconRecordTarget) {
      params.originalIconId = this.existingIconRecordTarget.dataset.id;
    }
    params.combinedIconFile = this.canvasOutlet.canvasBlob;
    params.combinedIconName = combinedIconName;
    params.renderPlan = this.canvasOutlet.renderPlan;

    this.dispatch("download", {
      detail: { params },
    });
  }

  drop(e) {
    e.preventDefault();
    this.dispatch("drop");

    const uploadFile = e.dataTransfer.files[0];
    if (!uploadFile) return;

    const isSetup = this.setup({ uploadFile });
    if (isSetup) this.uploadedImageTarget.files = e.dataTransfer.files;
  }

  updateDownloadState(event) {
    if (event.detail.hasText) {
      enableLink(this.downloadLinkTarget);
    } else {
      disableLink(this.downloadLinkTarget);
    }
  }
}

function setupOriginalImageUrl(uploadFile, existingIconRecord) {
  if (uploadFile) return URL.createObjectURL(uploadFile);

  if (existingIconRecord) return existingIconRecord.dataset.imageUrl;
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
  const limitSizeMB = MAX_FILE_SIZE * 1024 * 1024;
  return file.size < limitSizeMB;
}
