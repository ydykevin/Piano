public class Key {
  private boolean released=false;
  private boolean overBox=false;
  private boolean locked=false;
  private int x1;


  public  Key(int x2) {
    this.x1=x2;
  }

  public boolean isPressed() {
    locked=true;
    return locked;
  }

  public boolean isReleased() {
    released=true;
    return released;
  }


  public void play(int step)
  {
    if (!overBox) {
      fill(#FFFFFF);
      rect(step*x, 1, x, 2*y-10);
    }
    if (mouseX > step*x && mouseX < (step+1)*x) {
      overBox=true;
      if (locked) { 
        print("sdsdsdsd");
        fill(#C9C9C9);
        rect(step*x, 1, x, 2*y-10);
        return;
      }
    } else {
      fill(#FFFFFF);
      rect(step*x, 1, x, 2*y-10);
    }
  }
}
