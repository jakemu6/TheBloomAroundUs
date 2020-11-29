//KETAI


void mouseDragged() {
  for (int i = 0; i < flowergroup.size(); i++) {
    Flower f = flowergroup.get(i);
    if (f.selected(mouseX, mouseY) == true) {
      f.move(mouseX, mouseY);
    }
  }
}

void mousePressed() {
  //monthCol++;
  if(monthCol > 12) {
    monthCol = 1;
  }
}


void onLocationEvent(double _latitude, double _longitude) {
  longitude = _longitude;
  latitude = _latitude;
  streamOpen = true;
  if (streamOpen == true && streamUnopened == true) {
    openTwitterStream();
    streamUnopened = false;
  }
}

public boolean surfaceTouchEvent(MotionEvent event) {

  //call to keep mouseX, mouseY, etc updated
  super.surfaceTouchEvent(event);

  //forward event to class for processing
  return gesture.surfaceTouchEvent(event);
}
