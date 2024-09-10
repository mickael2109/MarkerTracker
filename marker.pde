import processing.video.*;
import jp.nyatla.nyar4psg.*;

Capture videoStream;
MultiMarker tracker;

void setup() {
  size(640, 480, P3D);
  println("Initialisation...");
  
  videoStream = new Capture(this, 640, 480);
  videoStream.start();
  
  String camParams = sketchPath("data/camera_para.dat");
  String[] markers = {
    sketchPath("data/patt.hiro"),
    sketchPath("data/patt.kanji")
  };

  if (camParams == null || markers[0] == null || markers[1] == null) {
    println("Erreur : fichiers manquants.");
    exit();
  }

  initTracker(camParams, markers);
}

void draw() {
  if (videoStream.available()) {
    videoStream.read();
    processFrame();
  }
}

void initTracker(String camParams, String[] markers) {
  try {
    tracker = new MultiMarker(this, width, height, camParams);
    for (String marker : markers) {
      tracker.addARMarker(marker, 80);
    }
  } catch (Exception e) {
    println("Erreur d'initialisation : " + e.getMessage());
    exit();
  }
}

void processFrame() {
  tracker.detect(videoStream);
  background(50);
  tracker.drawBackground(videoStream);

  for (int i = 0; i < 2; i++) {
    if (tracker.isExist(i)) {
      image(tracker.pickupRectImage(i, -30, -30, 80, 80, 100, 100), 20, 20);
      println("Marqueur " + i + " détecté !");
    } else {
      println("Aucun marqueur " + i);
    }
  }
}
