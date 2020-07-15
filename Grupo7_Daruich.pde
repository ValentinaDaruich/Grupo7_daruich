import oscP5.*;

import com.thomasdiewald.pixelflow.java.*;
import com.thomasdiewald.pixelflow.java.accelerationstructures.*;
import com.thomasdiewald.pixelflow.java.antialiasing.FXAA.*;
import com.thomasdiewald.pixelflow.java.antialiasing.GBAA.*;
import com.thomasdiewald.pixelflow.java.antialiasing.SMAA.*;
import com.thomasdiewald.pixelflow.java.fluid.*;


//----CALIBRACION

float MIN_AMP = 50;
float MAX_AMP = 80;

float MIN_PITCH = 60;
float MAX_PITCH = 90;

float GRADO_VARIACION = 10;

float fAmortiguacion = 0.9;

boolean monitor = false;

//---------

float amp, pitch;

OscP5 osc;

GestorSenial gAmp, gPitch;

int innerSize=30;
int XPos = mouseX;
float eRadius;
boolean toggle = false;
boolean haySonido;
boolean antesHabiaSonido;
// fluid simulation
DwFluid2D fluid;
// render target
PGraphics2D pg_fluid;

//---------------------FONDO-----------------------------------
PImage fondo;
//-------------------------------------------------------------


public void setup() {
  size(800, 752, P2D);
  // library context
  DwPixelFlow context = new DwPixelFlow(this);
  // fluid simulation
  fluid = new DwFluid2D(context, width, height, 1);
  // some fluid parameters
  fluid.param.dissipation_velocity = 0.80f;
  fluid.param.dissipation_density = 1f;
  pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
  eRadius=20;
  //Para el análisis de sonido
  osc = new OscP5(this, 12345);
  gAmp = new GestorSenial(MIN_AMP, MAX_AMP, fAmortiguacion);
  gPitch = new GestorSenial(MIN_PITCH, MAX_PITCH, fAmortiguacion);

  //estado inicial de la detección de sonido
  haySonido = false;
  antesHabiaSonido = false;

  fondo = loadImage("fonduchi_2.png");
}

public void draw() {
  gAmp.actualizar(amp);
  gPitch.actualizar(pitch);
  if (monitor) {
    gAmp.imprimir(50, 100);
    gPitch.imprimir(50, 220, 500, 100, false, true);
  }

  haySonido = gAmp.filtradoNorm() > 0;
  //amplitud mayor a 40 dibuja rosa 
  if (haySonido == true) {
    if ( pitch > 58 && pitch < 70) { //tono agudo, no importa la ampitud
      push();
      rotate(PI / 2.0);
      float px1 = 0;
      float py1 = 100;
      float vx1 = random (-100 , 200);
      float vy1 = eRadius ;
      if ( eRadius < 20 ) eRadius = 20;
      fluid.addVelocity(px1, py1, 100, vx1, vy1);
      fluid.addDensity (px1, py1, 30, 255, 0, 0, 1.0f, 3); //outer smoke
      fluid.addDensity (px1, py1, 120, 0, 0, 255, 1.0f, 1); //inner smoke
      pop();
    }
    //mancha azul, celeste y negra  
    if (amp > 80 && pitch >80) {//silvido
      push();
      float x5b = 100, y5b = 752 ;//y=752 x=100
      float vx5b = random(-20 , 20) ;//70
      float vy5b = -300;
      fluid.addVelocity(x5b, y5b, 100, vx5b, vy5b);
      fluid.addDensity (x5b, y5b, 40, 0f, 0.7f, .5f, 0.1f, 3); //outer smoke
      fluid.addDensity (x5b, y5b, 80, 0f, 0.1f, 0.7f, 120f, 3); //inner smoke
      pop();
    }
    //amplitud mayor a 90 dibuja pintura naranja y amarilla
    if (pitch < 55 && amp < 60) {//tono grave
      push();
      rotate(PI / 2.0);
      float px3 = width/2;
      float py3 = 0;
      float vx3 = 100;
      float vy3 = random(-100, 200);
      fluid.addVelocity(px3, py3, 100, vx3, vy3);
      fluid.addDensity (px3, py3, 80, 1f, 0.6f, 0.1f, 1.0f, 3); //outer smoke
      fluid.addDensity (px3, py3, 60, .5f, 1f, 0.1f, 1.0f, 1); //inner smoke
      pop();
    }
    //amplitud mayor a 90 dibuja pintura roja, amarilla y rosa
    if (pitch < 55 && amp > 80) {//tono grave
      push();
      rotate(PI / 2.0);
      //float px3 = width-80;
      float px3_ = 750;
      float py3_ = 280;
      float vx3_ = random(-300, 300);
      float vy3_ = 300;
      fluid.addVelocity(px3_, py3_, 100, vx3_, vy3_);
      fluid.addDensity (px3_, py3_, 80, 200, 0, 0, 1.0f, 3); //outer smoke
      fluid.addDensity (px3_, py3_, 60, 1f, 0.6f, 0.1f, 1.0f, 3); //outer smoke
      fluid.addDensity (px3_, py3_, 40, .1f, 0f, 1f, 1f, 3); //inner smoke
      pop();
    }
  }

  //silencio dibuja pintura azul y violeta
  if ( haySonido == false ) {
    push();
    float px2 = width/2;
    float py2 = height;
    float vx2 = random(-200, 200);//100
    float vy2 = -100;//eRadius - 90
    if ( eRadius < 20 ) eRadius = 20;
    fluid.addVelocity(px2, py2, 100, vx2, vy2);
    fluid.addDensity (px2, py2, 50, .5f, 0f, 1f, 1f, 3); //outer smoke
    fluid.addDensity (px2, py2, 100, 0f, 0f, 1f, 1.0f, 3); //inner smoke
    pop();
    push();

    //mancha amarilla
    float x5 = 0, y5 = height/2 ;
    float vx5 = 100;
    float vy5 = 0;
    fluid.addVelocity(x5, y5, 40, vx5, vy5);
    fluid.addDensity (x5, y5, 60, 0.5f, 0.6f, .25f, 0.75f, 3); //outer smoke
    fluid.addDensity (x5, y5, 20, 10, 255, 0, 1.0f, 3); //inner smoke
    pop();
  }


  fluid.addCallback_FluiData(new DwFluid2D.FluidData() {
    public void update(DwFluid2D fluid) {
    }
  }
  );

  fluid.update();

  pg_fluid.beginDraw();
  image(fondo, 0, 0);
  pg_fluid.endDraw();

  fluid.renderFluidTextures(pg_fluid, 0);
  filter(POSTERIZE, 110);//filtro para marcar planos de color
  image(pg_fluid, 0, 0);
  //capturar panalla
  saveFrame("prueba.png");
}

void oscEvent ( OscMessage m ) {

  if (m.addrPattern().equals("/amp")) {

    amp = m.get(0).floatValue();
  }
  if (m.addrPattern().equals("/pitch")) {

    pitch = m.get(0).floatValue();
  }
}
