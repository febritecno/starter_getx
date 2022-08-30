const APP_NAME = "logistika";
const BASE_URL = "http://ikateksiundip.id/logistika-dev";
const UPLOAD_PATH = "http://ikateksiundip.id/logistika-dev/uploads";
// const BASE_URL = "http://ikateksiundip.id/logistika-web";
// const UPLOAD_PATH = "http://ikateksiundip.id/logistika-web/uploads";
const IMAGE_PATH = 'assets/images/';
const ICON_PATH = 'assets/icons/';
const DEFAULT_IMAGE = '${IMAGE_PATH}Group 7044.png';
const NO_IMAGE = '${IMAGE_PATH}error-image.png';

abstract class AppConfig {
  static const String defaultFont = 'lato';
  static const double defaultTextSize = 14;
  static const double defaultTextLineHeight = 1.2;
  static const errorMessage = ['Error', 'Terjadi kesalahan'];
}
