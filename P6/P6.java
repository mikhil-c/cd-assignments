import syntaxtree.*;
import visitor.*;

public class P6 {
   public static void main(String[] args) {
      try {
         Node root = new MiniRAParser(System.in).Goal();
         Pass1 v1 = new Pass1<>();
         root.accept(v1, null);
      }
      catch (ParseException e) {
         System.out.println(e.toString());
      }
   }
} 


