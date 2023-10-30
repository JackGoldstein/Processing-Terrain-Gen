import controlP5.*;
ControlP5 gui;
Camera cam = new Camera();

Textfield terrain;

int cols = 10;
int rows = 10;
float gridSize = 30;
float heightMod = 1.0;
float snowThresh = 5.0;

float initialX = 0.0;
float initialY = 0.0;

boolean STROKE = false;
boolean COLOR = false;
boolean BLEND = false;

color snow = color(255,255,255);
color grass = color(143,170,64);
color rock = color(135,135,135);
color dirt = color(160,126,84);
color water = color(0,75,200);

ArrayList<PVector> vertex = new ArrayList<PVector>();
ArrayList<Integer> index = new ArrayList<Integer>();

void setup() 
{
  size(1200,800,P3D);
  gui = new ControlP5 (this);
  
  gui.addSlider("cols").setPosition(25,25)
                       .setRange(1,100)
                       .setSize(160,15)
                       .setCaptionLabel("ROWS");
                       
  gui.addSlider("rows").setPosition(25,50)
                       .setRange(1,100)
                       .setSize(160,15)
                       .setCaptionLabel("COLUMNS");
                       
  gui.addSlider("gridSize").setPosition(25,75)
                       .setRange(20,50)
                       .setSize(160,15)
                       .setCaptionLabel("TERRAIN SIZE");
  
  gui.addButton("GENERATE").setPosition(25,110)
                           .setSize(110,30);
                           
  terrain = gui.addTextfield("LOAD FROM FILE").setPosition(25,155)
                                              .setSize(200,30);
                                    
  gui.addToggle("STROKE").setPosition(350,25)
                         .setSize(50,25);
                         
  gui.addToggle("COLOR").setPosition(415,25)
                         .setSize(50,25);
                         
  gui.addToggle("BLEND").setPosition(480,25)
                         .setSize(50,25);
                         
  gui.addSlider("heightMod").setPosition(350,90)
                       .setRange(-5.0,5.0)
                       .setSize(160,15)
                       .setCaptionLabel("HEIGHT MODIFIER");
                       
  gui.addSlider("snowThresh").setPosition(350,120)
                       .setRange(1.0,5.0)
                       .setSize(160,15)
                       .setCaptionLabel("SNOW THRESHOLD");     
                       
  generateVertex();
  generateIndex();
}

void draw()
{
  
  initialX = mouseX;
  initialY = mouseY;
  
  background(0);
  
  cam.Update();
  
  if(STROKE)
    stroke(0);
  else
    noStroke();
  
  beginShape(TRIANGLES);
  for (int i = 0; i < index.size(); i++)
  {
    
    int point = index.get(i);
    PVector tri = vertex.get(point);
    
    
   
    if(COLOR)
    {
      float ratio = 0;
      color blend = color(0,0,0);
      float relativeHeight = (abs(tri.y) * heightMod)/snowThresh;
      
      if (relativeHeight >= 1.0) {
        relativeHeight = 1.0;
      }
     
      if(1.0>=relativeHeight && relativeHeight>=0.8) {
        if (BLEND) {
          ratio = (relativeHeight-0.8)/0.2f;
          blend = lerpColor(rock,snow,ratio);
          fill(blend);
        } else {
          fill(snow);
        }
      } else if (0.8>=relativeHeight && relativeHeight>=0.4) {
        if (BLEND) {
          ratio = (relativeHeight-0.4)/0.4f;
          blend = lerpColor(grass,rock,ratio);
          fill(blend);
        } else {
          fill(rock);
        }
      } else if (0.4>=relativeHeight && relativeHeight>=0.2) {
        if (BLEND) {
          ratio = (relativeHeight-0.2)/0.2f;
          blend = lerpColor(dirt,grass,ratio);
          fill(blend);
        } else {
          fill(grass);
        }
      } else if (0.2>=relativeHeight && relativeHeight>=0.0) {
        if (BLEND) {
          ratio = (relativeHeight)/0.2f;
          blend = lerpColor(water,dirt,ratio);
          fill(blend);
        } else {
          fill(water);
        }
      }
     
    } else {
      fill(255,255,255);
    }
    
    vertex(tri.x,tri.y*heightMod,tri.z);
  }
  endShape();
 
  //for CP5
  camera();
  perspective();
}

void isMouseOver() 
{
  
}

void mouseWheel(MouseEvent event) 
{
  
  cam.Zoom(event.getCount());
  
}

void mouseDragged()
{
  if(gui.isMouseOver() == false) 
  {
    float newX = mouseX;
    float newY = mouseY;
    
    float camX = newX-initialX;
    float camY = newY-initialY;
  
    cam.UpdateAngles(camX*0.35,camY*0.15);
  }
}

void GENERATE() 
{
  vertex.clear();      
  index.clear();
  generateVertex();
  generateIndex();
  
  PImage image = null;
  
  if (terrain.getText().isEmpty() == false) 
  {
    image = loadImage(terrain.getText() + ".png");
  }
  
  if (image != null)
  {
    changeTerrain(image);
  }
  
}

void generateVertex() 
{
  
  for(float i = -gridSize/2-(0.01); i <= (gridSize/2)+(0.01); i+=gridSize/rows) 
  {
    
    for(float j = -gridSize/2-(0.01); j <= (gridSize/2)+(0.01); j+=gridSize/cols)
    {
      
      PVector newVertex = new PVector(i,0,j);
      vertex.add(newVertex);
      
    }  
  }
}

void generateIndex()
{
  
  int startingIndex = 0;
  
  for(int j = 0; j < cols; j++)
  {
    
    for(int i = 0; i < rows; i++)
    {
      
      startingIndex = (i * (cols+1)+j);
      index.add(startingIndex);
      index.add(startingIndex+1);
      index.add(startingIndex+cols+1);
      
      index.add(startingIndex+1);
      index.add(startingIndex+cols+2);
      index.add(startingIndex+cols+1);
      
    }
  }
}

void changeTerrain(PImage image)
{
  for(int i = 0; i <= rows; i++)
  {
    
    for(int j = 0; j <= cols; j++)
    {
      
      int xIndex = int(map(j,0,cols+1,0,image.width-1));
      int yIndex = int(map(i,0,rows+1,0,image.height-1));
      int colorVal = image.get(yIndex,xIndex);
      
      float colorHeight = map(red(colorVal),0,255,0,1.0f);
      
      int index = (i*(cols+1))+j;
      vertex.get(index).y = -colorHeight;
    }
  }
}

void STROKE ()
{
  STROKE = !STROKE;
}

void COLOR ()
{
  COLOR = !COLOR;
}

void BLEND () 
{
  BLEND = !BLEND;
}
