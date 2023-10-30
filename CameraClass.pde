class Camera
{
  float radius = 30;
  float phi = 90;
  float theta = 105;
  float fov = 90;
  float xPos = radius * cos(radians(phi)) * sin(radians(theta));
  float yPos = radius * cos(radians(theta));
  float zPos = radius * sin(radians(theta)) * sin(radians(phi));
  
  void Update()
  {
     xPos = radius * cos(radians(phi)) * sin(radians(theta));
     yPos = radius * cos(radians(theta));
     zPos = radius * sin(radians(theta)) * sin(radians(phi));
     
     perspective(radians(fov),float(width)/height,0.1f,1000.0f);
     camera(xPos,yPos,zPos,  0,0,0,  0,1,0);
  }
  
  void Zoom(float zoomAmt)
  {
    
     if (radius > 190 && zoomAmt > 0) {
     } else if (radius < 20 && zoomAmt < 0) {
     } else {
        radius+=zoomAmt*10;
     }
     
  }
  
  void UpdateAngles (float xVal, float yVal)
  {
    
    phi += xVal;
   
    theta += yVal;
    if (theta >= 179) {
      theta = 179;
    } else if (theta <= 1) {
      theta = 1;
    }
     
  }
}
