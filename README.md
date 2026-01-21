# SOULSCAN

Project PAM

#### Note: DIKARENAKAN ADA CHAT BOT YANG MEMBUTUHKAN API KEY, MAKA API KEY SAYA TARUH DI FILE .ENV UNTUK MENJAGA KEAMANAN. CHAT BOT YANG SAYA GUNAKAN DARI GEMINI.AI

## Getting Started

## Copy Github
```bash
git clone https://github.com/IlhamYuniar16/Project-PAM-SMT-5.git
```

## Get Package
```bash 
flutter pub get
```

#### Run bisa menggunakan emulator atau hp sendiri, ( jika hp sendiri ikuti langkah "Run Handphone", jika emulator "Run Program" )

## Run Handphone
#### REFRENSI https://pub.dev/packages/flutter_launcher_icons
```bash 
dart run flutter_launcher_icons

# Bentuk flutter_launcher_icons di pubspec.yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icons/logonotext.png" # Sesuaikan Path-nya
  min_sdk_android: 21 
```
atau
```bash
dart run flutter_launcher_icons -f <your config file name here>

# Bentuk flutter_launcher_icons di file flutter_launcher_icons.yaml
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png" # Sesuaikan Path-nya
  min_sdk_android: 21

# Run Cepat
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
```
FUNGSINYA UNTUK MENGGANTI ICON FLUTTER MENJADI ICON ATAU LOGO DARI APLIKASI SOULSCAN 

### Note: Pastikan Menggunakan Android bukan IOS, dan Pastikan HP Tersambung Dengan Laptop Menggunakan Kabel Data

## Run Program
```bash
flutter run
```

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
