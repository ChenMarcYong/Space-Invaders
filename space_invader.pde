import processing.sound.*;


Main_menu Main_menu;
levels levels;
Menu Menu;
Sound Sound;
String game_state="main_screen";
void setup() {
  size(1000, 1000);
  initSounds();
  menu_theme_sound.loop();
  Main_menu = new Main_menu();
  levels = new levels();
  Menu= new Menu();
  Sound = new Sound();
  launch_profil();
  //menu_theme_sound.loop();
}


void draw() {
  if (!Menu.pause  && !Menu.highscore && !Menu.regle) {
    Main_menu.display_Main_screen();
    Main_menu.display_Main_menu();
    levels.start_level();
    levels.fin_level();
    Main_menu.loose_game();
    Main_menu.win_game();
    Main_menu.choose_a_name();
    Main_menu.delete_profile();
    if (game_state=="start_level") {
      game.drawIt();
      game.moves();
      game.handleKey();
    }
  }
  Menu.display_rules();
  Menu.display_highscore();
  Menu.drawIt();                                           // Pause.
}

void keyPressed() {
  if (key==ESC) {
    key=0;                                    //permet de ne pas quitter la fenêtre automatiquement (fonction de échap de base).
    if (!Menu.pause) {
      if (game_state!="main_screen" && game_state!="main_menu" && game_state!="name" &&  game_state!="fin_level"  && !Menu.highscore && game_state!="delete_profile") {
        saveFrame("pause_back/frame.png");
        Menu.im_load=false;
        Menu.pause=true;
      }
    }
  }
  if (game_state=="name") {
    if (Main_menu.name.length()<=9) {                           // Maximun 10 charactères.
      if (keyCode>=65 && keyCode<=90) {
        Main_menu.name+=key;
      } else if (keyCode>=96 && keyCode<=105) {
        Main_menu.name+=key;
      }
    }
    if (key==8) {
      if (Main_menu.name.length()>0) {
        Main_menu.name=Main_menu.name.substring(0, Main_menu.name.length()-1);
      }
    }
  }
  if (game_state=="start_level") {
    if (key == 'q' ||key == 'Q' || keyCode==37) {
      game._left = true;
    } else if (key == 'd'||key == 'D' || keyCode==39) {
      game._right = true;
    } else if (key == ' ') {
      game._shoot = true;
    }
  }
}
void keyReleased() {
  if (key == 'q' ||key == 'Q'|| keyCode==37) {                           // si on clic malencontreusement sur maj.
    game._left = false;
  } else if (key == 'd'||key == 'D'|| keyCode==39) {
    game._right = false;
  } else if (key == ' ') {
    game._shoot = false;
  }
}
