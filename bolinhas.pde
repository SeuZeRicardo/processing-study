//Influencias do Codigo
//http://www.ee.columbia.edu/~dpwe/resources/Processing/LiveSpectrum.pde

//Chamada das bibliotecas do Minim
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
FFT fft;

int sampleRate = 44100;
int timeSize = 1024;

boolean sketchFullScreen(){
  return true;
}

//Quantidade de Bolinhas
int n = 100;

//Posição de X e Y
float [] x = new float [n];
float [] y = new float [n];

//Velocidade de movimento
float [] vx = new float [n]; 
float [] vy = new float [n];


void setup() {
  size(displayWidth, displayHeight); 
  smooth();
  sketchFullScreen();
  noCursor();
  noStroke();
 
   for (int i=0; i<n; i++) {
    //Definiçãoo da posição inicial
    x[i] = width/2;
    y[i] = height/2;

    vx[i] = random(0, 1);
    vy[i] = random(0, 1);
  }  

  minim = new Minim(this);
  song = minim.loadFile("Fire.mp3", 512);
  song.loop();
  fft = new FFT(song.bufferSize(), song.sampleRate()); // make a new fft

  /* 
  calcular médias baseadas em uma oitava minima da largura de 11 Hz
  divide a cada oitava em uma banda - isso deve resultar em 12 médias
  o resultado das 12 médias, é equivalente a cada uma oitava, abrangendo 0 até 11 Hz.
  */
  fft.logAverages(11, 1);
}

void draw() {
  background(0);

  fft.forward(song.mix); // Vai pegar a musica indo para frente

   float bw = fft.getBandWidth(); // Retorna o valor do spectrum em Hz
   println(bw); //Teste

  for (int i = 0; i < 12; i++) {  // 12 são os numeros de bandas 
  
    int BaixaFreq;
    int AltaFreq;
    
    if ( i == 0 ) {
      BaixaFreq = 0;
    } 
    else {
      BaixaFreq = (int)((sampleRate/2) / (float)Math.pow(2, 12 - i));
    }

      AltaFreq = (int)((sampleRate/2) / (float)Math.pow(2, 11 - i));

    // Pegando a frenquencia alta e baixa
     BaixaFreq = fft.freqToIndex(BaixaFreq); 
     AltaFreq = fft.freqToIndex(AltaFreq); 



    // calcula a amplitude da banda
    float avg = fft.calcAvg(BaixaFreq, AltaFreq);
    // println(avg);
  

    for (int j=0; j<n; j++) {
      if ((BaixaFreq >= 16) || ( AltaFreq <= 32)) {
        
        //Declarações de cor RGB
        float r = random(255);
        float g = random(255);
        float b = random(255);

        fill(r,g,b);
        ellipseMode (CENTER);
        ellipse(x[j], y[j], avg/1, avg/1);
        x[j] += vx[j];
        y[j] += vy[j];
        
      //Define o limite da janela e faz a bolinha rebater.
        if ((x[j] < 0) || (x[j] > width-avg/2)) {
          vx[j] = -vx[j];
          }
          
        if ((y[j] < 0) || (y[j] > height-avg/2)) {
          vy[j] = -vy[j];
        } // fim do loop do if da janela 
      } // fim do if de low bounf
    } // Fim do loop de J
  } //Fim do Calculo de I
} // fim do draw

void stop() {  
  song.close(); 
  minim.stop(); 
  super.stop(); 
}

