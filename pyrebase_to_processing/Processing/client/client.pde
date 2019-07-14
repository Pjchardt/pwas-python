import processing.net.*; 
import processing.video.*;

Client myClient;
Capture cam;

PGraphics bufferA;
PGraphics bufferB;

PShader shader_buffer_a;
PShader shader_buffer_b;
PShader shader_final;

void setup() { 
  //fullScreen(P2D);
  size(600, 600, P2D); 
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  bufferA = createGraphics(width, height, P2D);
  bufferB = createGraphics(width, height, P2D);
  
  shader_buffer_a = loadShader("buffer_a_frag.glsl");
  shader_buffer_a.set("lastFrame", bufferA);
  
  shader_buffer_b = loadShader("buffer_b_frag.glsl");
  
  shader_final = loadShader("final_frag.glsl");
  shader_final.set("bufferB", bufferB);
  
  cam = new Capture(this, 640, 480, 30);
  cam.start();
} 

void draw() { 
  
  background(0, 0, 0);
  
  if (myClient.available() > 0) { 
    String inString = myClient.readString(); 
    println(inString); 
    JSONObject json = parseJSONObject(inString);
    if (json == null) 
    {
      println("JSONObject could not be parsed");
    } 
    else 
    {
      float intensity = json.getFloat("strength_2");
      shader_final.set("strength_2", intensity * 5);
      //pass value to shader
    }
  }
  
  if(cam.available()) {
    cam.read();
  }
  
  bufferA.beginDraw();
  bufferA.shader(shader_buffer_a);
  bufferA.image(cam, 0, 0, width, height);
  bufferA.endDraw();
  
  bufferB.beginDraw();
  bufferB.shader(shader_buffer_b);
  bufferB.image(cam, 0, 0, width, height);
  bufferB.endDraw();
  
  shader_final.set("u_time", millis() / 1000.0);
  shader(shader_final);
  image(bufferA, 0, 0);
}