import processing.net.*; 
import gohai.glvideo.*;
GLCapture video;

Client myClient;

PGraphics webcamBuffer;
PGraphics bufferA;
PGraphics bufferB;

PShader shader_buffer_a;
PShader shader_buffer_b;
PShader shader_final;

void setup() { 
  //fullScreen(P2D);
  size(640, 480, P2D); 
  
  myClient = new Client(this, "127.0.0.1", 5005);
  
  webcamBuffer = createGraphics(640, 480, P2D);
  bufferA = createGraphics(width, height, P2D);
  bufferB = createGraphics(width, height, P2D);
  
  shader_buffer_a = loadShader("buffer_a_frag.glsl");
  shader_buffer_a.set("lastFrame", bufferA);
  
  shader_buffer_b = loadShader("buffer_b_frag.glsl");
  
  shader_final = loadShader("final_frag.glsl");
  shader_final.set("bufferB", bufferB);
  
  String[] devices = GLCapture.list();
  if (devices.length < 1) {
    println("No capture device detected!");
    exit();
  }
  
  video = new GLCapture(this, devices[0], 640, 480);
  video.start();
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
      float str_2 = json.getFloat("strength_2");
      shader_final.set("speed_2", str_2 * 20);
      //pass value to shader
    }
  }
  
  if (video.available()) {
    video.read();
  }
  
  webcamBuffer.beginDraw();
  webcamBuffer.image(video, 0, 0);
  webcamBuffer.endDraw();
  
  bufferA.beginDraw();
  bufferA.shader(shader_buffer_a);
  bufferA.image(webcamBuffer, 0, 0, width, height);
  bufferA.endDraw();
  
  bufferB.beginDraw();
  bufferB.shader(shader_buffer_b);
  bufferB.image(webcamBuffer, 0, 0, width, height);
  bufferB.endDraw();
  
  shader_final.set("u_time", millis() / 1000.0);
  shader(shader_final);
  image(bufferA, 0, 0);
}
