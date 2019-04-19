//定義
int ball_num = 0;
int score = 0;
int[] blockX = new int[80],blockY = new int[80]; 
int[] flag = new int[80];
GanarateBlock[] block = new GanarateBlock[80]; 
int clicked=0;
int life = 3;
boolean start_click = true;   
ArrayList<Ball> ballball = new ArrayList<Ball>(); 


//クラスGanarateBlock
class GanarateBlock{
  int x, y;
  color c;
 GanarateBlock(int bx, int by,int flag){
    x = bx;
    y = by;
    if(flag == 0){
      c=color(100);
    }else{
      c=color(0);
    }
  }
  void init(){
    fill(c);
    rect(x, y, 38,30);
  }
}
//-----------------------------------------------------------------------//
//クラスBallの宣言
class Ball {
  float x;
  float y;
  float vx = 3;
  float vy = -2;
  float dir = 1; //方向左, 右
  
  Ball(){
    x = 200;
    y = 490;
  }
  
  void show(){
    if(start_click){
      x += vx;
      y += vy;
    }
    //左側の壁の当たり判定
    if( x + 10 > 400){
       dir = -1;
       x = 400 - 10;//場所のリセット
       vx *= -1;
    }
    //右側の壁の当たり判定
    if( x < 0){
       dir = 1;
       x = 0;//場所のリセット
       vx *= -1;
    }
    //上の壁
    if(y < 0){
      vy *= -1;
    }
    
    
    if (this.x > my_bar.x && this.x < my_bar.x + 100) {
      if(this.y > my_bar.y){
        vx += random(-0.6,0.6);
        vy *= -1.01;
      }
    } 
    
    ellipse(this.x,this.y,10,10);
  }
}
//-----------------------------------------------------------------------//
//クラスBarの宣言
class Bar {
  float x; 
  float y;
  float bar_w = 100;
  float bar_h = 10;
  
  Bar(){
    x = 150;
    y = 500;
  }

  //オブジェクトを描画するメソッド（オブジェクトの内部の関数）
  void show(){
      fill(100);
      rect(x, y, bar_w, bar_h);
  }

  //右に移動するメソッド（オブジェクトの内部の関数）
  void moveRight(){
    x += 10.0;
  }

  //左に移動するメソッド（オブジェクトの内部の関数）
  void moveLeft(){
    x -= 10.0;
  }
}

Bar my_bar; //ボールを保持するための大域変数


//-----------------------------------------------------------------------//
void setup(){
  size(400,600);
  for(int y = 0; y < 8; y++){
    for(int x = 0; x <10; x++){
      
      int i = x + (y * 10);
      if (y%2 == 0 || x == 0 || x == 9) { flag[i] = 1; }
      blockX[i] = 10 + 38 * x;
      blockY[i] = 10 + 30 * y;
      block[i] = new GanarateBlock(blockX[i], blockY[i],flag[i]);
    }
  }
  
  colorMode(HSB,100);
  ellipseMode(RADIUS); //中心と半径を指定
  background(0); //背景を白に
  my_bar = new Bar(); //クラスBarのオブジェクト（インスタンス）を生成
  create();
}
//-----------------------------------------------------------------------//
void create() {
  fill(100);
  ball_num++;
  ballball.add(new Ball());
  text("↑キー2回押してください",width/2-70,height/2);
}
//-----------------------------------------------------------------------//
void draw(){
  if(clicked >= 1){
    background(0); //背景を白に
    for(int i = 0; i < block.length; i++){
      block[i].init();
    }
    my_bar.show(); //描画メソッド
    hantei();
  }
  text("life" + life + "/3", 90, height-20);
  text("スコア："+score, 10 ,10); 
  text("↑キーで一時停止/再生", 270, 580);
  text("↓キーでボール生成", 270, 560);
  
  if ( life <= 0 ) {
    text("ゲームオーバー", width/2-40, height/2);
    text("あなたのスコア:"+score, width/2-35, height/2+20);
    start_click = false;
  }
}
//-----------------------------------------------------------------------//
void keyPressed(){ //キーが押された時に呼び出される関数
  if (key == CODED) {//キーが特殊キーかの判定
     if(keyCode == RIGHT) {//右矢印なら 
       my_bar.moveRight(); //my_barオブジェクトのmoveRight()メソッドを実行
     } else if (keyCode == LEFT) {//左矢印なら
       my_bar.moveLeft(); //my_barオブジェクトのmoveLeft()メソッドを実行
     } else if(keyCode == UP) {
       clicked++;
       start_click = !start_click;
     } else if(keyCode == DOWN){
       start_click = true;
       ball_num++;
       ballball.add(new Ball());
     }
   }
}

void hantei(){
  for(int s=3-life; s<ball_num; s++){
    ballball.get(s).show();
      for(int y_ = 0; y_ < 8; y_++){
        for(int x_ = 0; x_ < 10; x_++){
          int i = x_ + (y_ * 10);
          blockX[i] = 10 + 38 * x_;
          blockY[i] = 10 + 30 * y_;
          
          if(flag[i]<1){            
            if(ballball.get(s).y > blockY[i]  && ballball.get(s).y < blockY[i] + 30 ){
              if(ballball.get(s).x > blockX[i]  && ballball.get(s).x < blockX[i] + 38 ){
               
                ballball.get(s).vy *= -1;
                flag[i]++;
                score += 10;                   
              }
            }
            //横に当たったら
            if(ballball.get(s).y > blockY[i]  && ballball.get(s).y < blockY[i] + 30 ){
              
              if(ballball.get(s).x > blockX[i]  && ballball.get(s).x < blockX[i]  ){
                ballball.get(s).vx *= -1;
                flag[i]++;
              }
              if(ballball.get(s).x > blockX[i] +38  && ballball.get(s).x < blockX[i] + 38 ){
                ballball.get(s).vx *= -1;
                flag[i]++;
              }
            }         
          }    
         block[i] = new GanarateBlock(blockX[i], blockY[i],flag[i]);   
        }
     }
     if( ballball.get(s).y > height){
        life--; 
     }
     if( score == 320){
       text("ゲームクリア", width/2-40, height/2);
       start_click = false;
     }
  }
}